// ignore_for_file: unused_element

library dashboard;

//import 'dart:convert';
import 'dart:convert';
import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/models/event_json.dart';
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
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// binding
part '../../bindings/portal_mp_binding.dart';

// controller
part '../../controllers/portal_mp_controller.dart';

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

class PortalMpScreen extends GetView<PortalMpController> {
  const PortalMpScreen({Key? key}) : super(key: key);

  List<Event> _getEventsfromDay(DateTime date) {
    //print(selectedEvents.length);
    return controller.selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
          ]);
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kBorderRadius),
                      bottomRight: Radius.circular(kBorderRadius),
                    ),
                    child: _Sidebar(data: controller.getSelectedProject())),
              ),
              Flexible(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: kSpacing),
                      _buildHeader(),
                      const SizedBox(height: kSpacing * 2),
                      /*_buildProgress(),
                      const SizedBox(height: kSpacing * 2),
                      const SizedBox(height: kSpacing * 2),
                      const SizedBox(height: kSpacing), */
                      /* StaggeredGrid.count(
                        crossAxisCount: 10,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 6,
                            mainAxisCellCount: 3,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 350,
                              height: 300,
                              child: Chart(
                                data: lineMarkerData,
                                variables: {
                                  'day': Variable(
                                    accessor: (Map datum) =>
                                        datum['day'] as String,
                                    scale: OrdinalScale(inflate: true),
                                  ),
                                  'value': Variable(
                                    accessor: (Map datum) =>
                                        datum['value'] as num,
                                    scale: LinearScale(
                                      max: 15,
                                      min: -3,
                                      tickCount: 7,
                                      formatter: (v) => '${v.toInt()} ℃',
                                    ),
                                  ),
                                  'group': Variable(
                                    accessor: (Map datum) =>
                                        datum['group'] as String,
                                  ),
                                },
                                elements: [
                                  LineElement(
                                    position: Varset('day') *
                                        Varset('value') /
                                        Varset('group'),
                                    color: ColorAttr(
                                      variable: 'group',
                                      values: [
                                        const Color(0xff5470c6),
                                        const Color(0xff91cc75),
                                      ],
                                    ),
                                  ),
                                ],
                                axes: [
                                  Defaults.horizontalAxis,
                                  Defaults.verticalAxis,
                                ],
                                selections: {
                                  'tooltipMouse': PointSelection(on: {
                                    GestureType.hover,
                                  }, devices: {
                                    PointerDeviceKind.mouse
                                  }, variable: 'day', dim: Dim.x),
                                  'tooltipTouch': PointSelection(on: {
                                    GestureType.scaleUpdate,
                                    GestureType.tapDown,
                                    GestureType.longPressMoveUpdate
                                  }, devices: {
                                    PointerDeviceKind.touch
                                  }, variable: 'day', dim: Dim.x),
                                },
                                tooltip: TooltipGuide(
                                  followPointer: [true, true],
                                  align: Alignment.topLeft,
                                  variables: ['group', 'value'],
                                ),
                                crosshair: CrosshairGuide(
                                  followPointer: [false, true],
                                ),
                                annotations: [
                                  LineAnnotation(
                                    dim: Dim.y,
                                    value: 11.14,
                                    style: StrokeStyle(
                                      color: const Color(0xff5470c6)
                                          .withAlpha(100),
                                      dash: [2],
                                    ),
                                  ),
                                  LineAnnotation(
                                    dim: Dim.y,
                                    value: 1.57,
                                    style: StrokeStyle(
                                      color: const Color(0xff91cc75)
                                          .withAlpha(100),
                                      dash: [2],
                                    ),
                                  ),
                                  MarkAnnotation(
                                    relativePath: Paths.circle(
                                        center: Offset.zero, radius: 5),
                                    style: Paint()
                                      ..color = const Color(0xff5470c6),
                                    values: ['Wed', 13],
                                  ),
                                  MarkAnnotation(
                                    relativePath: Paths.circle(
                                        center: Offset.zero, radius: 5),
                                    style: Paint()
                                      ..color = const Color(0xff5470c6),
                                    values: ['Sun', 9],
                                  ),
                                  MarkAnnotation(
                                    relativePath: Paths.circle(
                                        center: Offset.zero, radius: 5),
                                    style: Paint()
                                      ..color = const Color(0xff91cc75),
                                    values: ['Tue', -2],
                                  ),
                                  MarkAnnotation(
                                    relativePath: Paths.circle(
                                        center: Offset.zero, radius: 5),
                                    style: Paint()
                                      ..color = const Color(0xff91cc75),
                                    values: ['Thu', 5],
                                  ),
                                  TagAnnotation(
                                    label: Label(
                                        '13',
                                        LabelStyle(
                                          style: Defaults.textStyle,
                                          offset: const Offset(0, -10),
                                        )),
                                    values: ['Wed', 13],
                                  ),
                                  TagAnnotation(
                                    label: Label(
                                        '9',
                                        LabelStyle(
                                          style: Defaults.textStyle,
                                          offset: const Offset(0, -10),
                                        )),
                                    values: ['Sun', 9],
                                  ),
                                  TagAnnotation(
                                    label: Label(
                                        '-2',
                                        LabelStyle(
                                          style: Defaults.textStyle,
                                          offset: const Offset(0, -10),
                                        )),
                                    values: ['Tue', -2],
                                  ),
                                  TagAnnotation(
                                    label: Label(
                                        '5',
                                        LabelStyle(
                                          style: Defaults.textStyle,
                                          offset: const Offset(0, -10),
                                        )),
                                    values: ['Thu', 5],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: 3,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: 350,
                              height: 300,
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: 350,
                                height: 300,
                                child: Chart(
                                  data: basicData,
                                  variables: {
                                    'genre': Variable(
                                      accessor: (Map map) =>
                                          map['genre'] as String,
                                    ),
                                    'sold': Variable(
                                      accessor: (Map map) => map['sold'] as num,
                                    ),
                                  },
                                  elements: [
                                    IntervalElement(
                                      label: LabelAttr(
                                          encoder: (tuple) =>
                                              Label(tuple['sold'].toString())),
                                      elevation:
                                          ElevationAttr(value: 0, updaters: {
                                        'tap': {true: (_) => 5}
                                      }),
                                      color: ColorAttr(
                                          value: Defaults.primaryColor,
                                          updaters: {
                                            'tap': {
                                              false: (color) =>
                                                  color.withAlpha(100)
                                            }
                                          }),
                                    )
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tap': PointSelection(dim: Dim.x)
                                  },
                                  tooltip: TooltipGuide(),
                                  crosshair: CrosshairGuide(),
                                ),
                              ),
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Stack(
                              children: [
                                Chart(
                                  data: areaStackGradientData,
                                  variables: {
                                    'day': Variable(
                                      accessor: (Map datum) =>
                                          datum['day'] as String,
                                      scale: OrdinalScale(inflate: true),
                                    ),
                                    'value': Variable(
                                      accessor: (Map datum) =>
                                          datum['value'] as num,
                                      scale: LinearScale(min: 0, max: 1500),
                                    ),
                                    'group': Variable(
                                      accessor: (Map datum) =>
                                          datum['group'].toString(),
                                    ),
                                  },
                                  elements: [
                                    AreaElement(
                                      position: Varset('day') *
                                          Varset('value') /
                                          Varset('group'),
                                      shape: ShapeAttr(
                                          value: BasicAreaShape(smooth: true)),
                                      gradient: GradientAttr(
                                        variable: 'group',
                                        values: [
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(
                                                  204, 128, 255, 165),
                                              Color.fromARGB(204, 1, 191, 236),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 0, 221, 255),
                                              Color.fromARGB(204, 77, 119, 255),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 55, 162, 255),
                                              Color.fromARGB(204, 116, 21, 219),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 0, 135),
                                              Color.fromARGB(204, 135, 0, 157),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 191, 0),
                                              Color.fromARGB(204, 224, 62, 76),
                                            ],
                                          ),
                                        ],
                                        updaters: {
                                          'groupMouse': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                          'groupTouch': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                        },
                                      ),
                                      modifiers: [StackModifier()],
                                    ),
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tooltipMouse': PointSelection(on: {
                                      GestureType.hover,
                                    }, devices: {
                                      PointerDeviceKind.mouse
                                    }, variable: 'day'),
                                    'groupMouse': PointSelection(
                                        on: {
                                          GestureType.hover,
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.mouse}),
                                    'tooltipTouch': PointSelection(on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate
                                    }, devices: {
                                      PointerDeviceKind.touch
                                    }, variable: 'day'),
                                    'groupTouch': PointSelection(
                                        on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.touch}),
                                  },
                                  tooltip: TooltipGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [true, true],
                                    align: Alignment.topLeft,
                                  ),
                                  crosshair: CrosshairGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [false, true],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Stack(
                              children: [
                                Chart(
                                  data: areaStackGradientData,
                                  variables: {
                                    'day': Variable(
                                      accessor: (Map datum) =>
                                          datum['day'] as String,
                                      scale: OrdinalScale(inflate: true),
                                    ),
                                    'value': Variable(
                                      accessor: (Map datum) =>
                                          datum['value'] as num,
                                      scale: LinearScale(min: 0, max: 1500),
                                    ),
                                    'group': Variable(
                                      accessor: (Map datum) =>
                                          datum['group'].toString(),
                                    ),
                                  },
                                  elements: [
                                    AreaElement(
                                      position: Varset('day') *
                                          Varset('value') /
                                          Varset('group'),
                                      shape: ShapeAttr(
                                          value: BasicAreaShape(smooth: true)),
                                      gradient: GradientAttr(
                                        variable: 'group',
                                        values: [
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(
                                                  204, 128, 255, 165),
                                              Color.fromARGB(204, 1, 191, 236),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 0, 221, 255),
                                              Color.fromARGB(204, 77, 119, 255),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 55, 162, 255),
                                              Color.fromARGB(204, 116, 21, 219),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 0, 135),
                                              Color.fromARGB(204, 135, 0, 157),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 191, 0),
                                              Color.fromARGB(204, 224, 62, 76),
                                            ],
                                          ),
                                        ],
                                        updaters: {
                                          'groupMouse': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                          'groupTouch': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                        },
                                      ),
                                      modifiers: [StackModifier()],
                                    ),
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tooltipMouse': PointSelection(on: {
                                      GestureType.hover,
                                    }, devices: {
                                      PointerDeviceKind.mouse
                                    }, variable: 'day'),
                                    'groupMouse': PointSelection(
                                        on: {
                                          GestureType.hover,
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.mouse}),
                                    'tooltipTouch': PointSelection(on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate
                                    }, devices: {
                                      PointerDeviceKind.touch
                                    }, variable: 'day'),
                                    'groupTouch': PointSelection(
                                        on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.touch}),
                                  },
                                  tooltip: TooltipGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [true, true],
                                    align: Alignment.topLeft,
                                  ),
                                  crosshair: CrosshairGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [false, true],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Stack(
                              children: [
                                Chart(
                                  data: areaStackGradientData,
                                  variables: {
                                    'day': Variable(
                                      accessor: (Map datum) =>
                                          datum['day'] as String,
                                      scale: OrdinalScale(inflate: true),
                                    ),
                                    'value': Variable(
                                      accessor: (Map datum) =>
                                          datum['value'] as num,
                                      scale: LinearScale(min: 0, max: 1500),
                                    ),
                                    'group': Variable(
                                      accessor: (Map datum) =>
                                          datum['group'].toString(),
                                    ),
                                  },
                                  elements: [
                                    AreaElement(
                                      position: Varset('day') *
                                          Varset('value') /
                                          Varset('group'),
                                      shape: ShapeAttr(
                                          value: BasicAreaShape(smooth: true)),
                                      gradient: GradientAttr(
                                        variable: 'group',
                                        values: [
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(
                                                  204, 128, 255, 165),
                                              Color.fromARGB(204, 1, 191, 236),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 0, 221, 255),
                                              Color.fromARGB(204, 77, 119, 255),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 55, 162, 255),
                                              Color.fromARGB(204, 116, 21, 219),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 0, 135),
                                              Color.fromARGB(204, 135, 0, 157),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 191, 0),
                                              Color.fromARGB(204, 224, 62, 76),
                                            ],
                                          ),
                                        ],
                                        updaters: {
                                          'groupMouse': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                          'groupTouch': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                        },
                                      ),
                                      modifiers: [StackModifier()],
                                    ),
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tooltipMouse': PointSelection(on: {
                                      GestureType.hover,
                                    }, devices: {
                                      PointerDeviceKind.mouse
                                    }, variable: 'day'),
                                    'groupMouse': PointSelection(
                                        on: {
                                          GestureType.hover,
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.mouse}),
                                    'tooltipTouch': PointSelection(on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate
                                    }, devices: {
                                      PointerDeviceKind.touch
                                    }, variable: 'day'),
                                    'groupTouch': PointSelection(
                                        on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.touch}),
                                  },
                                  tooltip: TooltipGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [true, true],
                                    align: Alignment.topLeft,
                                  ),
                                  crosshair: CrosshairGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [false, true],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Stack(
                              children: [
                                Chart(
                                  data: areaStackGradientData,
                                  variables: {
                                    'day': Variable(
                                      accessor: (Map datum) =>
                                          datum['day'] as String,
                                      scale: OrdinalScale(inflate: true),
                                    ),
                                    'value': Variable(
                                      accessor: (Map datum) =>
                                          datum['value'] as num,
                                      scale: LinearScale(min: 0, max: 1500),
                                    ),
                                    'group': Variable(
                                      accessor: (Map datum) =>
                                          datum['group'].toString(),
                                    ),
                                  },
                                  elements: [
                                    AreaElement(
                                      position: Varset('day') *
                                          Varset('value') /
                                          Varset('group'),
                                      shape: ShapeAttr(
                                          value: BasicAreaShape(smooth: true)),
                                      gradient: GradientAttr(
                                        variable: 'group',
                                        values: [
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(
                                                  204, 128, 255, 165),
                                              Color.fromARGB(204, 1, 191, 236),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 0, 221, 255),
                                              Color.fromARGB(204, 77, 119, 255),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 55, 162, 255),
                                              Color.fromARGB(204, 116, 21, 219),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 0, 135),
                                              Color.fromARGB(204, 135, 0, 157),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 191, 0),
                                              Color.fromARGB(204, 224, 62, 76),
                                            ],
                                          ),
                                        ],
                                        updaters: {
                                          'groupMouse': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                          'groupTouch': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                        },
                                      ),
                                      modifiers: [StackModifier()],
                                    ),
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tooltipMouse': PointSelection(on: {
                                      GestureType.hover,
                                    }, devices: {
                                      PointerDeviceKind.mouse
                                    }, variable: 'day'),
                                    'groupMouse': PointSelection(
                                        on: {
                                          GestureType.hover,
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.mouse}),
                                    'tooltipTouch': PointSelection(on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate
                                    }, devices: {
                                      PointerDeviceKind.touch
                                    }, variable: 'day'),
                                    'groupTouch': PointSelection(
                                        on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.touch}),
                                  },
                                  tooltip: TooltipGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [true, true],
                                    align: Alignment.topLeft,
                                  ),
                                  crosshair: CrosshairGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [false, true],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 2,
                            mainAxisCellCount: 1,
                            child: Stack(
                              children: [
                                Chart(
                                  data: areaStackGradientData,
                                  variables: {
                                    'day': Variable(
                                      accessor: (Map datum) =>
                                          datum['day'] as String,
                                      scale: OrdinalScale(inflate: true),
                                    ),
                                    'value': Variable(
                                      accessor: (Map datum) =>
                                          datum['value'] as num,
                                      scale: LinearScale(min: 0, max: 1500),
                                    ),
                                    'group': Variable(
                                      accessor: (Map datum) =>
                                          datum['group'].toString(),
                                    ),
                                  },
                                  elements: [
                                    AreaElement(
                                      position: Varset('day') *
                                          Varset('value') /
                                          Varset('group'),
                                      shape: ShapeAttr(
                                          value: BasicAreaShape(smooth: true)),
                                      gradient: GradientAttr(
                                        variable: 'group',
                                        values: [
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(
                                                  204, 128, 255, 165),
                                              Color.fromARGB(204, 1, 191, 236),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 0, 221, 255),
                                              Color.fromARGB(204, 77, 119, 255),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 55, 162, 255),
                                              Color.fromARGB(204, 116, 21, 219),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 0, 135),
                                              Color.fromARGB(204, 135, 0, 157),
                                            ],
                                          ),
                                          const LinearGradient(
                                            begin: Alignment(0, 0),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color.fromARGB(204, 255, 191, 0),
                                              Color.fromARGB(204, 224, 62, 76),
                                            ],
                                          ),
                                        ],
                                        updaters: {
                                          'groupMouse': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                          'groupTouch': {
                                            false: (gradient) => LinearGradient(
                                                  begin: const Alignment(0, 0),
                                                  end: const Alignment(0, 1),
                                                  colors: [
                                                    gradient.colors.first
                                                        .withAlpha(25),
                                                    gradient.colors.last
                                                        .withAlpha(25),
                                                  ],
                                                ),
                                          },
                                        },
                                      ),
                                      modifiers: [StackModifier()],
                                    ),
                                  ],
                                  axes: [
                                    Defaults.horizontalAxis,
                                    Defaults.verticalAxis,
                                  ],
                                  selections: {
                                    'tooltipMouse': PointSelection(on: {
                                      GestureType.hover,
                                    }, devices: {
                                      PointerDeviceKind.mouse
                                    }, variable: 'day'),
                                    'groupMouse': PointSelection(
                                        on: {
                                          GestureType.hover,
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.mouse}),
                                    'tooltipTouch': PointSelection(on: {
                                      GestureType.scaleUpdate,
                                      GestureType.tapDown,
                                      GestureType.longPressMoveUpdate
                                    }, devices: {
                                      PointerDeviceKind.touch
                                    }, variable: 'day'),
                                    'groupTouch': PointSelection(
                                        on: {
                                          GestureType.scaleUpdate,
                                          GestureType.tapDown,
                                          GestureType.longPressMoveUpdate
                                        },
                                        variable: 'group',
                                        devices: {PointerDeviceKind.touch}),
                                  },
                                  tooltip: TooltipGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [true, true],
                                    align: Alignment.topLeft,
                                  ),
                                  crosshair: CrosshairGuide(
                                    selections: {
                                      'tooltipTouch',
                                      'tooltipMouse'
                                    },
                                    followPointer: [false, true],
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 3,
                            mainAxisCellCount: 4,
                            child: _buildRecentMessages(
                                data: controller.getChatting()),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: 4,
                            child: Obx(() => Visibility(
                                  replacement: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  visible: controller.calendarFlag.value,
                                  child: Obx(
                                    () => TableCalendar(
                                      locale: 'languageCalendar'.tr,
                                      focusedDay: controller.focusedDay.value,
                                      firstDay: DateTime(2000),
                                      lastDay: DateTime(2100),
                                      calendarFormat: controller.format.value,
                                      calendarStyle: const CalendarStyle(
                                        markerDecoration: BoxDecoration(
                                            color: Colors.yellow,
                                            shape: BoxShape.circle),
                                        todayDecoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      headerStyle: const HeaderStyle(
                                        //formatButtonVisible: false,
                                        formatButtonShowsNext: false,
                                      ),
                                      startingDayOfWeek:
                                          StartingDayOfWeek.monday,
                                      daysOfWeekVisible: true,
                                      onFormatChanged:
                                          (CalendarFormat _format) {
                                        controller.format.value = _format;
                                      },
                                      onDaySelected: (DateTime selectDay,
                                          DateTime focusDay) {
                                        controller.selectedDay.value =
                                            selectDay;
                                        controller.focusedDay.value = focusDay;
                                        controller.eventFlag.value = false;
                                        controller.eventFlag.value = true;
                                      },
                                      selectedDayPredicate: (DateTime date) {
                                        return isSameDay(
                                            controller.selectedDay.value, date);
                                      },
                                      onHeaderLongPressed: (date) {
                                        /* Get.off(const CreateCalendarEvent(),
                              arguments: {"adUserId": adUserId}); */
                                      },
                                      eventLoader: _getEventsfromDay,
                                    ),
                                  ),
                                )),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 3,
                            mainAxisCellCount: 4,
                            child: Obx(() => Visibility(
                                visible: controller.eventFlag.value,
                                child: _buildDayEvents())),
                          ),
                        ],
                      ) */
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    /*  Obx(() => Visibility(
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          visible: controller.calendarFlag.value,
                          child: Obx(
                            () => TableCalendar(
                              locale: 'languageCalendar'.tr,
                              focusedDay: controller.focusedDay.value,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              calendarFormat: controller.format.value,
                              calendarStyle: const CalendarStyle(
                                markerDecoration: BoxDecoration(
                                    color: Colors.yellow,
                                    shape: BoxShape.circle),
                                todayDecoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              headerStyle: const HeaderStyle(
                                //formatButtonVisible: false,
                                formatButtonShowsNext: false,
                              ),
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              daysOfWeekVisible: true,
                              onFormatChanged: (CalendarFormat _format) {
                                controller.format.value = _format;
                              },
                              onDaySelected:
                                  (DateTime selectDay, DateTime focusDay) {
                                controller.selectedDay.value = selectDay;
                                controller.focusedDay.value = focusDay;
                                controller.eventFlag.value = false;
                                controller.eventFlag.value = true;
                              },
                              selectedDayPredicate: (DateTime date) {
                                return isSameDay(
                                    controller.selectedDay.value, date);
                              },
                              onHeaderLongPressed: (date) {
                                /* Get.off(const CreateCalendarEvent(),
                            arguments: {"adUserId": adUserId}); */
                              },
                              eventLoader: _getEventsfromDay,
                            ),
                          ),
                        )), */
                    /*  Obx(() => Visibility(
                        visible: controller.eventFlag.value,
                        child: _buildDayEvents())), */
                  ],
                ),
              )
            ],
          );

          /* Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(
                onPressedMenu: () => Scaffold.of(context).openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            _buildProgress(axis: Axis.vertical),
            const SizedBox(height: kSpacing),
            _buildTeamMember(data: controller.getMember()),
            const SizedBox(height: kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: GetPremiumCard(onPressed: () {}),
            ),
            /* const SizedBox(height: kSpacing * 2),
            _buildTaskOverview(
              data: controller.getAllTask(),
              headerAxis: Axis.vertical,
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing * 2),
            _buildActiveProject(
              data: controller.getActiveProject(),
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ), */
            const SizedBox(height: kSpacing),
            _buildRecentMessages(data: controller.getChatting()),
          ]);
 */
        },
      )),
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

  Widget _buildDayEvents() {
    return Column(children: [
      ..._getEventsfromDay(controller.selectedDay.value).map(
        (Event event) => /* ListTile(
                title: Text(
                  event.title,
                ),
              ), */
            Card(
          elevation: 8.0,
          //margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: const EdgeInsets.only(right: 12.0),
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white24))),
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  tooltip: 'Edit Event'.tr,
                  onPressed: () {
                    /* Get.off(const EditCalendarEvent(), arguments: {
                            "id": event.id,
                            "name": event.title,
                            "description": event.description,
                            "typeId": event.typeId,
                            "startDate": event.scheduledStartDate,
                            "startTime": event.scheduledStartTime,
                            "endTime": event.scheduledEndTime,
                            "statusId": event.statusId,
                          }); */
                  },
                ),
              ),
              title: Text(
                event.cBPartner,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.timelapse,
                  color: event.statusId == "DR"
                      ? Colors.yellow
                      : event.statusId == "CO"
                          ? Colors.green
                          : event.statusId == "IN"
                              ? Colors.grey
                              : event.statusId == "PR"
                                  ? Colors.orange
                                  : event.statusId == "IP"
                                      ? Colors.white
                                      : event.statusId == "CF"
                                          ? Colors.lightGreen
                                          : event.statusId == "NY"
                                              ? Colors.red
                                              : event.statusId == "WP"
                                                  ? Colors.yellow
                                                  : Colors.red,
                ),
                onPressed: () {},
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        event.title,
                        style: const TextStyle(color: Colors.white),
                      )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                      Text(
                        '${event.startDate}   ${event.scheduledStartTime} - ${event.scheduledEndTime}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: [
                Visibility(
                  visible: event.refname != 'N/A' ? true : false,
                  child: Row(
                    children: [
                      Text(
                        "User : ".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(event.refname),
                    ],
                  ),
                ),
                Visibility(
                  visible: event.phone != 'N/A' ? true : false,
                  child: Row(
                    children: [
                      Text(
                        "Phone: ".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        tooltip: 'Call',
                        onPressed: () {
                          //log("info button pressed");
                          if (event.phone != 'N/A') {
                            //makePhoneCall(event.phone.toString());
                          }
                        },
                      ),
                      Text(event.phone),
                    ],
                  ),
                ),
                Visibility(
                  visible: event.ref2name != 'N/A' ? true : false,
                  child: Row(
                    children: [
                      Text(
                        "User 2: ".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(event.ref2name),
                    ],
                  ),
                ),
                Visibility(
                  visible: event.phone2 != 'N/A' ? true : false,
                  child: Row(
                    children: [
                      Text(
                        "Phone 2: ".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        tooltip: 'Call',
                        onPressed: () {
                          //log("info button pressed");
                          if (event.phone != 'N/A') {
                            //makePhoneCall(event.phone.toString());
                          }
                        },
                      ),
                      Text(event.phone2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
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

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? kNotifColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

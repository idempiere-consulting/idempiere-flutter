part of dashboard;

class MaintenanceMpResourceFireExtinguisherController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  late WorkOrderResourceLocalJson _trx;
  var _hasCallSupport = false;

  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    getWorkOrders();
    //getADUserID();
  }

  bool get dataAvailable => _dataAvailable.value;
  WorkOrderResourceLocalJson get trx => _trx;
  //String get value => _value.toString();

  changeFilter() {
    getWorkOrders();
  }

  Future<void> getWorkOrders() async {
    _dataAvailable.value = false;
    //print(GetStorage().read('workOrderResourceSync'));
    if (GetStorage().read('workOrderSync') != null) {
      _trx = WorkOrderResourceLocalJson.fromJson(
          jsonDecode(GetStorage().read('workOrderResourceSync')));
      // ignore: unnecessary_null_comparison
      _dataAvailable.value = _trx != null;
    }
  }

  //test grid

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'N°',
      field: 'N°',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Location',
      field: 'Location',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Barcode',
      field: 'Barcode',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Serial N°',
      field: 'SerialNo',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Cartel',
      field: 'Cartel',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Manufacturer',
      field: 'Manufacturer',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Year',
      field: 'Year',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'ShutDown Type',
      field: 'ShutDownType',
      type: PlutoColumnType.select(<String>[
        'A',
        'B',
        'C',
      ]),
    ),
    PlutoColumn(
      title: 'Type',
      field: 'Type',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Check',
      field: 'Check',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Revision',
      field: 'Revision',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Testing',
      field: 'Testing',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Observations',
      field: 'Observations',
      type: PlutoColumnType.text(),
    ),
    /*PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ), */
  ];

  final List<PlutoRow> rows = [
    /* PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user1'),
        'name': PlutoCell(value: 'Mike'),
        'age': PlutoCell(value: 20),
        'role': PlutoCell(value: 'Programmer'),
        'joined': PlutoCell(value: '2021-01-01'),
        'working_time': PlutoCell(value: '09:00'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user2'),
        'name': PlutoCell(value: 'Jack'),
        'age': PlutoCell(value: 25),
        'role': PlutoCell(value: 'Designer'),
        'joined': PlutoCell(value: '2021-02-01'),
        'working_time': PlutoCell(value: '10:00'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user3'),
        'name': PlutoCell(value: 'Suzi'),
        'age': PlutoCell(value: 40),
        'role': PlutoCell(value: 'Owner'),
        'joined': PlutoCell(value: '2021-03-01'),
        'working_time': PlutoCell(value: '11:00'),
      },
    ), */
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Identification', fields: [
      'N°',
      'Location',
      'Barcode',
      'SerialNo',
      'Cartel',
      'Manufacturer',
      'Year'
    ]),
    PlutoColumnGroup(
        title: 'Activities',
        fields: ['ShutDownType', 'Type', 'Check', 'Revision', 'Testing']),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  void handleAddRows() {
    final newRows = stateManager.getNewRows(count: 1);

    /* for (var e in newRows) {
      e.cells['status']!.value = 'created';
    } */

    stateManager.appendRows(newRows);

    stateManager.setCurrentCell(
      newRows.first.cells.entries.first.value,
      stateManager.refRows.length - 1,
    );

    stateManager.moveScrollByRow(
      PlutoMoveDirection.down,
      stateManager.refRows.length - 2,
    );

    stateManager.setKeepFocus(true);
  }

  //end test grid

  // Data
  _Profile getProfil() {
    //"userName": "Flavia Lonardi", "password": "Fl@via2021"
    String userName = GetStorage().read('user') as String;
    String roleName = GetStorage().read('rolename') as String;
    return _Profile(
      photo: const AssetImage(ImageRasterPath.avatar1),
      name: userName,
      email: roleName,
    );
  }

  List<TaskCardData> getAllTask() {
    //List<TaskCardData> list;

    return [
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/leads');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Lead",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.inProgress,
        totalContributors: 30,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar1),
          const AssetImage(ImageRasterPath.avatar2),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar6),
          const AssetImage(ImageRasterPath.avatar7),
          const AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {},
        addFunction: () {},
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "iDempiere APP",
      releaseTime: DateTime.now(),
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: "Taxi Online",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: "E-Movies Mobile",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: "Video Converter App",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }

  List<ImageProvider> getMember() {
    return const [
      AssetImage(ImageRasterPath.avatar1),
      AssetImage(ImageRasterPath.avatar2),
      AssetImage(ImageRasterPath.avatar3),
      AssetImage(ImageRasterPath.avatar4),
      AssetImage(ImageRasterPath.avatar5),
      AssetImage(ImageRasterPath.avatar6),
    ];
  }

  List<ChattingCardData> getChatting() {
    return const [
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];
  }
}

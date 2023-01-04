part of dashboard;

class PortalMpTrainingCourseCourseListController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: prefer_final_fields
  var _dataAvailable = false.obs;
  // ignore: prefer_final_fields
  var _dataAvailable1 = false.obs;
  late CourseListJson _trxCourses;
  late CourseStudentJson _trxStudents;
  //var passwordFieldController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var businessPartnerId;

  // ignore: prefer_final_fields
  var _selectedCourse = 10000.obs;
  // ignore: prefer_final_fields
  var _selectedStudent = 0.obs;
  // ignore: prefer_final_fields
  var _courseId = 0.obs;
  // ignore: prefer_final_fields
  var _showStudentDetails = false.obs;

  // ignore: prefer_final_fields
  bool _newStudent = true;

  // ignore: prefer_final_fields
  List<TextEditingController> _studentFields =
      List.generate(7, (i) => TextEditingController());

  var date = "";

  late List<Types> courseDropDownList;
  var courseSearchFieldController = TextEditingController();
  var courseSearchFilterValue = "".obs;
  var courseDropdownValue = "1".obs;
  final courseJson = {
    "types": [
      {"id": "1", "name": "DocumentNo".tr},
      {"id": "2", "name": "Name".tr},
      {"id": "3", "name": "Business Partner".tr},
    ]
  };

  late List<Types> studentDropDownList;
  var studentSearchFieldController = TextEditingController();
  var studentSearchFilterValue = "".obs;
  var studentDropdownValue = "1".obs;
  final studentJson = {
    "types": [
      {"id": "1", "name": "Name".tr},
      {"id": "2", "name": "Birthplace".tr},
      {"id": "3", "name": "Birthday".tr},
    ]
  };

  CourseListJson get trxCourses => _trxCourses;
  CourseStudentJson get trxStudents => _trxStudents;
  bool get dataAvailable => _dataAvailable.value;
  bool get dataAvailable1 => _dataAvailable1.value;
  set dataAvailable1(show) => _dataAvailable1.value = show;

  get selectedCourse => _selectedCourse.value;
  set selectedCourse(index) => _selectedCourse.value = index;

  int get courseId => _courseId.value;
  set courseId(id) => _courseId.value = id;

  int get selectedStudent => _selectedStudent.value;
  set selectedStudent(index) => _selectedStudent.value = index;

  bool get showStudentDetails => _showStudentDetails.value;
  set showStudentDetails(show) => _showStudentDetails.value = show;

  List<TextEditingController> get studentFields => _studentFields;
  //set studentFields(list) => _studentFields = list;

  bool get newStudent => _newStudent;
  set newStudent(value) => _newStudent = value;

  @override
  void onInit() {
    super.onInit();
    courseDropDownList = getTypes(courseJson)!;
    studentDropDownList = getTypes(studentJson)!;
    getCourseSurveys();
  }

  List<Types>? getTypes(json) {
    var dJson = TypeJson.fromJson(json);

    return dJson.types;
  }

  Future<void> getBusinessPartner() async {
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    var url = Uri.parse('http://' +
        ip +
        '/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);

      GetStorage().write('BusinessPartnerName',
          json["records"][0]["C_BPartner_ID"]["identifier"]);
      GetStorage().write(
          'BusinessPartnerId', json["records"][0]["C_BPartner_ID"]["id"]);

      businessPartnerId = json["records"][0]["C_BPartner_ID"]["id"];
    } else {
      //print(response.body);
    }
  }

  getCourseSurveys() async {
    await getBusinessPartner();
    _dataAvailable.value = false;
    //final adUserId = GetStorage().read('userId');
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/mp_maintain?\$filter= WindowType eq \'T\' and C_BPartner_ID eq $businessPartnerId'); //and AD_Client_ID eq ${GetStorage().read('clientid')}
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      _trxCourses = CourseListJson.fromJson(jsonDecode(response.body));
      _dataAvailable.value = _trxCourses.records!.isNotEmpty;
    } else {
      _dataAvailable.value = false;
    }
  }

  getCourseStudents() async {
    _dataAvailable1.value = false;
    //final adUserId = GetStorage().read('userId');
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/mp_maintain_resource?\$filter= Mp_Maintain_ID eq $courseId'); //and AD_Client_ID eq ${GetStorage().read('clientid')}
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      _trxStudents = CourseStudentJson.fromJson(jsonDecode(response.body));
      _dataAvailable1.value = _trxStudents.records!.isNotEmpty;
    } else {
      _dataAvailable1.value = false;
    }
  }

  initFieldsController(index, newStudent) {
    _showStudentDetails.value = false;
    if (_studentFields.length != 7) {
      for (int i = 1; i < 8; i++) {
        _studentFields.add(TextEditingController());
      }
    }
    if (newStudent) {
      _studentFields[0].text = '';
      _studentFields[1].text = '';
      _studentFields[2].text = '';
      _studentFields[3].text = '';
      _studentFields[4].text = '';
      _studentFields[5].text = '';
      _studentFields[6].text = '';
      date = "";
    } else {
      _studentFields[0].text = _trxStudents.records?[index].name ?? '';
      _studentFields[1].text = _trxStudents.records?[index].surname ?? '';
      _studentFields[2].text = _trxStudents.records?[index].birthcity ?? '';
      //_studentFields[3].text = _trxStudents.records?[index].birthday ?? '';
      if (date != "") {
        _studentFields[3].text = date;
      } else {
        _studentFields[3].text = _trxStudents.records?[index].birthday ?? '';
      }
      date = "";

      _studentFields[4].text = _trxStudents.records?[index].email ?? '';
      _studentFields[5].text = _trxStudents.records?[index].position ?? '';
      _studentFields[6].text = _trxStudents.records?[index].taxcode ?? '';
    }
    _showStudentDetails.value = true;
  }

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

class Provider extends GetConnect {
  Future<void> getLeads() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    //print(authorization);
    //String clientid = GetStorage().read('clientid');
    /* final response = await get(
      'http://' + ip + '/api/v1/windows/lead',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      return response.body;
    } */

    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/windows/lead');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var json = jsonDecode(response.body);
      //print(json['window-records'][0]);
      return json;
    } else {
      return Future.error(response.body);
    }
  }
}

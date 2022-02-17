part of dashboard;

class DashboardController extends GetxController {
  /* final scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  var notificationCounter = 0.obs;

  var value = "Sign Entry".obs;
  var notDoneCount = 0.obs;
  var inProgressCount = 0.obs;
  var doneCount = 0.obs;

  var filters = ["Sign Entry", "Sign Exit" /* , "Team" */];
  var filterCount = 0;

  @override
  void onInit() {
    super.onInit();
    getNotificationCounter();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    var now = DateTime.now();
    //DateTime fiftyDaysAgo = now.subtract(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    print('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and JP_ToDo_ScheduledStartDate eq \'$formattedDate\'');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/jp_todo?\$filter= JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and JP_ToDo_ScheduledStartDate eq \'$formattedDate\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var json = EventJson.fromJson(jsonDecode(response.body));

      for (var i = 0; i < json.rowcount!; i++) {
        switch (json.records![i].jPToDoStatus!.id) {
          case "NY":
            notDoneCount.value++;
            break;
          case "WP":
            inProgressCount.value++;
            break;
          case "CO":
            doneCount.value++;
            break;
          default:
        }
      }

      //print(json.rowcount);
    } else {
      throw Exception("Failed to load events");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  changeFilter() {
    //print("kiao");
    filterCount++;
    if (filterCount == 2) {
      filterCount = 0;
    }

    value.value = filters[filterCount];
  }

  Future<void> getNotificationCounter() async {
    if (GetStorage().read("isOffline") == false) {
      var userid = GetStorage().read("userId");
      final ip = GetStorage().read('ip');
      String authorization = 'Bearer ' + GetStorage().read('token');
      final protocol = GetStorage().read('protocol');
      var url = Uri.parse('$protocol://' +
          ip +
          '/api/v1/models/lit_mobile_checkread?\$filter= SalesRep_ID eq $userid and AD_Client_ID eq ${GetStorage().read("clientid")}');
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
        notificationCounter.value = json["row-count"];
      }
    }
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
        seeAllFunction: () {},
        addFunction: () {
          notificationCounter.value = 99;
        },
        title: "Landing page UI Design",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.todo,
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

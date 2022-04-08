part of dashboard;

class HumanResourceWorkHoursController extends GetxController {
  /* final scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */
  late Timer timer;

  late bool isAvailable;

  DateTime savedDate = DateTime.now();

  var date = (DateFormat.yMMMEd().format(DateTime.now())).obs;

  var time = (DateFormat('hh:mm:ss').format(DateTime.now())).obs;

  @override
  void onInit() {
    nfcSessionLoad();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    NfcManager.instance.stopSession();
  }

  Future<void> nfcSessionLoad() async {
    isAvailable = await NfcManager.instance.isAvailable();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        if (ndef!.cachedMessage?.records[0].payload != null &&
            (DateTime.now()).difference(savedDate).inSeconds > 3) {
          savedDate = DateTime.now();
          final ip = GetStorage().read('ip');
          String authorization = 'Bearer ' + GetStorage().read('token');
          final protocol = GetStorage().read('protocol');
          var text =
              String.fromCharCodes(ndef.cachedMessage!.records[0].payload);

          var text2 = text.substring(1);
          var url = Uri.parse('$protocol://' +
              ip +
              '/api/v1/models/ad_user?\$filter= DocumentNo eq \'$text2\'');

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
            if (json["row-count"] > 0) {
              Get.defaultDialog(
                title: "Welcome",
                content: Text(json["records"][0]["Name"]),
                barrierDismissible: false,
                buttonColor: kNotifColor,
              );

              sendNfcTriggerInfo(savedDate, json["records"][0]["id"], text2);
              Future.delayed(const Duration(seconds: 2), () {
                Get.back();
              });
            }
          } else {
            Get.defaultDialog(
              title: 'Error!',
              content: Text(response.body),
              barrierDismissible: false,
              //textConfirm: 'Confirm',
              buttonColor: kNotifColor,
            );
            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
            });
          }
        }

        /* var text = String.fromCharCodes(ndef.cachedMessage!.records[0].payload);
        Get.defaultDialog(
          title: String.fromCharCodes(ndef.additionalData["identifier"]),
          content: Text(text),
          barrierDismissible: false,
          textConfirm: 'Confirm',
          textCancel: 'Cancel',
          buttonColor: kNotifColor,
        ); */
      },
    );
  }

  Future<void> sendNfcTriggerInfo(
      DateTime triggerDate, int userId, String nfcCode) async {
    var hourTime = "00";

    var minuteTime = "00";

    var formatter = DateFormat('yyyy-MM-dd');

    if (triggerDate.hour < 10) {
      hourTime = "0${triggerDate.hour}";
    } else {
      hourTime = "${triggerDate.hour}";
    }

    if (triggerDate.minute < 10) {
      minuteTime = "0${triggerDate.minute}";
    } else {
      minuteTime = "${triggerDate.minute}";
    }

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' + ip + '/api/v1/models/lit_workhour/');

    var msg = jsonEncode({
      "AD_User_ID": {"id": userId},
      "DocumentNo": nfcCode,
      "DateStart": '${formatter.format(triggerDate)}T$hourTime:$minuteTime:00Z',
    });

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print(response.body);
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      Get.snackbar(
        "Error!",
        response.body,
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  void _getTime() {
    date.value = (DateFormat.yMMMEd().format(DateTime.now()));
    time.value = (DateFormat('hh:mm:ss').format(DateTime.now()));
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
          Get.toNamed('/Lead');
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
        seeAllFunction: () {
          Get.toNamed('/Opportunity');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Opportunità",
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
        seeAllFunction: () {
          Get.toNamed('/Contatti');
        },
        addFunction: () {},
        title: "Contatti Business Partner",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          const AssetImage(ImageRasterPath.avatar5),
          const AssetImage(ImageRasterPath.avatar3),
          const AssetImage(ImageRasterPath.avatar4),
          const AssetImage(ImageRasterPath.avatar2),
        ],
      ),
      TaskCardData(
        seeAllFunction: () {
          Get.toNamed('/Clienti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Clienti BP",
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
        seeAllFunction: () {
          Get.toNamed('/Task&Appuntamenti');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Task e Appuntamenti",
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
        seeAllFunction: () {
          Get.toNamed('/Offerte');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Offerte",
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
        seeAllFunction: () {
          Get.toNamed('/Fattura');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Fatture di Vendita",
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
        seeAllFunction: () {
          Get.toNamed('/Incassi');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Incassi",
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
        seeAllFunction: () {
          Get.toNamed('/Provvigioni');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Provvigioni",
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
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "CRM",
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

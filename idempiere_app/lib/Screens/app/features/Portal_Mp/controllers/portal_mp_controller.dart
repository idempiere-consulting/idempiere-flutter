part of dashboard;

class PortalMpController extends GetxController {
  var calendarFlag = false.obs;
  var eventFlag = false.obs;
  var focusedDay = (DateTime.now()).obs;
  var selectedDay = (DateTime.now()).obs;
  //final _monthDayFormat = DateFormat('MM-dd');
  Rx<CalendarFormat> format = (CalendarFormat.month).obs;

  var totalHours = 0.0.obs;
  var totalTickets = 0.obs;
  var businessPartnerId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
    getBusinessPartner();
  }

  Future<void> getAllEvents() async {
    calendarFlag.value = false;
    var now = DateTime.now();
    DateTime fiftyDaysAgo = now.subtract(const Duration(days: 60));
    DateTime sixtyDaysLater = now.add(const Duration(days: 60));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedFiftyDaysAgo = formatter.format(fiftyDaysAgo);
    String formattedSixtyDaysLater = formatter.format(sixtyDaysLater);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_mobile_jp_todo_v?\$filter= JP_ToDo_Type eq \'S\' and AD_User_ID eq ${GetStorage().read('userId')} and JP_ToDo_ScheduledStartDate ge \'$formattedFiftyDaysAgo 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedSixtyDaysLater 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var json =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<EventRecords>? list = json.records;

      for (var i = 0; i < json.records!.length; i++) {
        //print(list![i].jPToDoScheduledStartTime);
        var formatter = DateFormat('yyyy-MM-dd');
        var date = DateTime.parse(list![i].jPToDoScheduledStartDate!);

        if (selectedEvents[
                DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] !=
            null) {
          selectedEvents[
                  DateTime.parse('${formatter.format(date)} 00:00:00.000Z')]!
              .add(
            Event(
                id: list[i].id!,
                userId: list[i].aDUserID?.id ?? 0,
                userName: list[i].aDUserID?.identifier ?? "",
                workOrderId: list[i].mpotid?.id ?? 0,
                workOrderName: list[i].mpotid?.identifier ?? "",
                type: list[i].jPToDoType!.identifier ?? "???",
                typeId: list[i].jPToDoType!.id!,
                status: list[i].jPToDoStatus!.identifier ?? "???",
                statusId: list[i].jPToDoStatus!.id!,
                title: list[i].name ?? "???",
                description: list[i].description ?? "",
                scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "",
                startDate: formatter.format(date),
                scheduledStartTime:
                    list[i].jPToDoScheduledStartTime!.substring(0, 5),
                scheduledEndTime:
                    list[i].jPToDoScheduledEndTime!.substring(0, 5),
                phone: list[i].phone ?? "N/A",
                phone2: list[i].phone2 ?? "N/A",
                refname: list[i].refname ?? "N/A",
                ref2name: list[i].ref2name ?? "N/A",
                cBPartner: list[i].cBPartnerID?.identifier ?? ""),
          );
        } else {
          selectedEvents[
              DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] = [
            Event(
                id: list[i].id!,
                userId: list[i].aDUserID?.id ?? 0,
                userName: list[i].aDUserID?.identifier ?? "",
                workOrderId: list[i].mpotid?.id ?? 0,
                workOrderName: list[i].mpotid?.identifier ?? "",
                type: list[i].jPToDoType!.identifier ?? "???",
                typeId: list[i].jPToDoType!.id!,
                status: list[i].jPToDoStatus!.identifier ?? "???",
                statusId: list[i].jPToDoStatus!.id!,
                title: list[i].name ?? "???",
                description: list[i].description ?? "",
                scheduledStartDate: list[i].jPToDoScheduledStartDate ?? "???",
                startDate: formatter.format(date),
                scheduledStartTime:
                    list[i].jPToDoScheduledStartTime!.substring(0, 5),
                scheduledEndTime:
                    list[i].jPToDoScheduledEndTime!.substring(0, 5),
                phone: list[i].phone ?? "N/A",
                phone2: list[i].phone2 ?? "N/A",
                refname: list[i].refname ?? "N/A",
                ref2name: list[i].ref2name ?? "N/A",
                cBPartner: list[i].cBPartnerID?.identifier ?? "")
          ];
        }
      }
      calendarFlag.value = true;

      //print(json.rowcount);
    } else {
      //throw Exception("Failed to load events");
      if (kDebugMode) {
        print(response.body);
      }
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<void> getHours() async {
    DateTime today = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    DateTime thirtyDaysAgo = today.subtract(const Duration(days: 30));
    String formattedThirtyDaysAgo = formatter.format(thirtyDaysAgo);
    String formattedToday = formatter.format(today);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_customer_hours_v?\$filter= AD_Client_ID eq ${GetStorage().read('clientid')} and AssignDateFrom ge \'$formattedThirtyDaysAgo 00:00:00\' and C_BPartner_ID eq ${businessPartnerId.value}');
    //print(url);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);

      var _trx =
          HoursReviewJSON.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      totalHours.value = 0.0;

      for (var element in _trx.records!) {
        totalHours.value += (element.qty ?? 0).toDouble();
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getBusinessPartner() async {
    final protocol = GetStorage().read('protocol');
    var name = GetStorage().read("user");
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/ad_user?\$filter= Name eq \'$name\' and AD_Client_ID eq ${GetStorage().read('clientid')}');
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

      businessPartnerId.value = json["records"][0]["C_BPartner_ID"]["id"];
      //print(businessPartnerId);
      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      //print(response.body);
    }
    getHours();
    getTickets();
  }

  Future<void> getTickets() async {
    DateTime today = DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(Duration(days: 50));

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    /* print('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= R_Status_ID neq $closedTicketId and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}${apiUrlFilter[filterCount]}$notificationFilter and ($ticketFilter)'); */
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/r_request?\$filter= R_Status_ID neq 1000024 and R_Status_ID neq 1000030  and C_BPartner_ID eq $businessPartnerId and AD_Client_ID eq ${GetStorage().read('clientid')}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      //print(response.body);
      var _trx =
          TicketsJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      totalTickets.value = _trx.rowcount ?? 0;

      //print(trx.rowcount);
      //print(response.body);
      // ignore: unnecessary_null_comparison
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Map<DateTime, List<Event>> selectedEvents = {};

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
          Get.toNamed('/Maintenance');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Maintenance",
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
          Get.toNamed('/MaintenanceCalendar');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "MaintenanceCalendar",
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
          Get.toNamed('/TicketCustomerTicket');
        },
        addFunction: () {},
        title: "Ticket customer",
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
    ];
  }

  ProjectCardData getSelectedProject() {
    return ProjectCardData(
      percent: .3,
      projectImage: const AssetImage(ImageRasterPath.logo1),
      projectName: "Portale Cliente",
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

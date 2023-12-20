part of dashboard;

class EmployeeResourceCalendarSlotController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  var args = Get.arguments;
  var flag = false.obs;
  Map<DateTime, List<Event>> selectedEvents = {};

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  CalendarFormat format = CalendarFormat.month;

  List<Event> selectedDayEventList = [];

  var listAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllEvents();
  }

  List<Event> getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  List<Event> getEventsfromDay2(DateTime date) {
    listAvailable.value = false;
    selectedDayEventList = selectedEvents[date] ?? [];
    listAvailable.value = true;
    return selectedEvents[date] ?? [];
  }

  Future<void> getAllEvents() async {
    flag.value = false;
    var now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime sixtyDaysLater = now.add(const Duration(days: 30));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedYesterday = formatter.format(yesterday);
    String formattedSixtyDaysLater = formatter.format(sixtyDaysLater);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_jp_todo_v?\$filter=  JP_ToDo_Type eq \'S\' and AD_User_ID eq ${args['id']} and JP_ToDo_ScheduledStartDate ge \'$formattedYesterday 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedSixtyDaysLater 23:59:59\'');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var json =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<EventRecords>? list = json.records;

      if (json.pagecount! > 1) {
        int index = 1;
        getAllEventsPages(json, index);
      } else {
        selectedEvents.removeWhere((key, value) => true);
        for (var i = 0; i < json.records!.length; i++) {
          //print('hallo');
          //print(list![i].mpotid?.id);
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
                  userName: list[i].aDUserID?.identifier ?? "",
                  userId: list[i].aDUserID?.id ?? 0,
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
                  cBPartner: list[i].cBPartnerID?.identifier ?? "",
                  createdby: list[i].createdBy!.identifier),
            );
          } else {
            selectedEvents[
                DateTime.parse('${formatter.format(date)} 00:00:00.000Z')] = [
              Event(
                  id: list[i].id!,
                  userName: list[i].aDUserID?.identifier ?? "",
                  userId: list[i].aDUserID?.id ?? 0,
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
                  cBPartner: list[i].cBPartnerID?.identifier ?? "",
                  createdby: list[i].createdBy!.identifier)
            ];
          }
        }

        flag.value = true;
      }
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

  Future<void> getAllEventsPages(EventJson json, int index) async {
    var now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime sixtyDaysLater = now.add(const Duration(days: 30));
    var formatter = DateFormat('yyyy-MM-dd');
    //String formattedDate = formatter.format(now);
    String formattedYesterday = formatter.format(yesterday);
    String formattedSixtyDaysLater = formatter.format(sixtyDaysLater);
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_jp_todo_v?\$filter=  JP_ToDo_Type eq \'S\' and AD_User_ID eq ${args['id']} and JP_ToDo_ScheduledStartDate ge \'$formattedYesterday 00:00:00\' and JP_ToDo_ScheduledStartDate le \'$formattedSixtyDaysLater 23:59:59\'&\$skip=${(index * 100)}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      index += 1;
      //print(response.body);
      var pageJson =
          EventJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      List<EventRecords>? list = json.records;

      for (var element in pageJson.records!) {
        json.records!.add(element);
      }

      if (json.pagecount! > index) {
        getAllEventsPages(json, index);
      } else {
        selectedEvents.removeWhere((key, value) => true);
        for (var i = 0; i < json.records!.length; i++) {
          //print('hallo');
          //print(list![i].mpotid?.id);
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
        flag.value = true;
      }
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
          Get.toNamed('/Ticket');
        },
        addFunction: () {
          //Get.toNamed('/createLead');
          log('hallooooo');
        },
        title: "Ticket",
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
          Get.toNamed('/TicketTicket');
        },
        addFunction: () {},
        title: "Ticket TIcket",
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
      projectName: "Mezzi e Attrezzature",
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

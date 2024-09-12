part of dashboard;

class PermissionCustomizationController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();

  int userId = 0;

  TextEditingController userFieldController = TextEditingController();

  int copyFromuserId = 0;

  TextEditingController copyFromUserFieldController = TextEditingController();

  var boolAccessList = List.generate(200, (i) => false.obs);

  List<String> binaryPermList = [];

  @override
  void onInit() {}

  Future<List<CRecords>> getAllLoginUsers() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_User?\$filter= DateLastLogin neq null and AD_Client_ID eq ${GetStorage().read("clientid")}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    if (response.statusCode == 200) {
      var json = ContactsJson.fromJson(jsonDecode(response.body));

      //print(json.rowcount);

      return json.records!;
    } else {
      throw Exception("Failed to load users");
    }

    //print(response.body);
  }

  Future<void> hexToBinPermissionString(String permString) async {
    if (permString == "") {}
    //boolAccessList = List.generate(200, (i) => false.obs);
    binaryPermList = [];
    var hexList = permString.split("-");

    for (var i = 0; i < hexList.length; i++) {
      binaryPermList.add(int.parse(hexList[i], radix: 16)
          .toRadixString(2)
          .padLeft(8, "0")
          .toString());

      if (binaryPermList.last[1] == "1") {
        boolAccessList[i].value = true;
      }
    }
  }

  Future<void> binToHexPermissionString() async {
    var newHexString = "";

    for (var i = 0; i < binaryPermList.length; i++) {
      newHexString =
          "$newHexString${i == 0 ? "" : "-"}${int.parse(binaryPermList[i], radix: 2).toRadixString(16)}";
    }

    print(newHexString);

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final msg = jsonEncode({
      "lit_mobilerole": newHexString,
    });
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/models/ad_user/$userId');
    //print(msg);
    var response = await http.put(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
  }

  Future<void> copyPermissionFromUser() async {
    Get.defaultDialog(
        title: 'Copy From'.tr,
        content: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: FutureBuilder(
                future: getAllLoginUsers(),
                builder: (BuildContext ctx,
                        AsyncSnapshot<List<CRecords>> snapshot) =>
                    snapshot.hasData
                        ? TypeAheadField<CRecords>(
                            direction: AxisDirection.down,
                            //getImmediateSuggestions: true,
                            textFieldConfiguration: TextFieldConfiguration(
                              onChanged: (value) {
                                if (value == "") {
                                  copyFromuserId = 0;
                                }
                              },
                              controller: copyFromUserFieldController,
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
                              copyFromUserFieldController.text =
                                  suggestion.name!;
                              copyFromuserId = suggestion.id!;
                              hexToBinPermissionString(
                                  suggestion.litmobilerole ?? "");
                              Get.back();
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
          ],
        ));
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

  // Data
  // ignore: library_private_types_in_public_api
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

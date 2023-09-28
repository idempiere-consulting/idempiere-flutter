part of dashboard;

class SupplychainMaintenanceSwitchResourceController extends GetxController {
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  RefListResourceTypeJson _tt = RefListResourceTypeJson(records: []);
  WorkOrderResourceLocalJson maintainResourceList =
      WorkOrderResourceLocalJson(records: []);
  // ignore: prefer_final_fields
  var dataAvailable = false.obs;

  var fromMaintainId = "0".obs;

  var toMaintainId = "0".obs;

  TextEditingController barcodeSearch = TextEditingController();

  late FocusNode myFocusNode;

  Future<List<Records>> getAllWarehouseMaintenances() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_maintain?\$filter= contains(tolower(DocumentNo),\'sede\')');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonsectors = MPMaintainContractJSON.fromJson(jsondecoded);

      return jsonsectors.records!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to load sectors");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  getProductSelected(int id, int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Product?\$filter= M_Product_ID eq $id');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonproduct = ProductJson.fromJson(jsondecoded);

      getProductCategoryEDIType(
          jsonproduct.records![0].mProductCategoryID!.id!, index);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to get product category");
    }
  }

  getProductCategoryEDIType(int id, int index) async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/M_Product_Category?\$filter= M_Product_Category_ID eq $id');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var jsondecoded = jsonDecode(response.body);

      var jsonprodcat = ProductCategoryJSON.fromJson(jsondecoded);

      Get.to(const EditSupplychainSwitchMpResource(), arguments: {
        "perm": await getPerm(jsonprodcat.records![0].ediType!.id!),
        "id": maintainResourceList.records![index].id,
        "number": maintainResourceList.records![index].number,
        "lineNo": maintainResourceList.records![index].lineNo.toString(),
        "cartel": maintainResourceList.records![index].textDetails,
        "model": maintainResourceList.records![index].lITProductModel,
        "dateOrder": maintainResourceList.records![index].dateOrdered,
        "years": maintainResourceList.records![index].useLifeYears != null
            ? maintainResourceList.records![index].useLifeYears.toString()
            : "0",
        "user": maintainResourceList.records![index].userName,
        "serviceDate": maintainResourceList.records![index].serviceDate,
        "productName":
            maintainResourceList.records![index].mProductID!.identifier,
        "productId": maintainResourceList.records![index].mProductID!.id,
        "cartelFormatId":
            maintainResourceList.records![index].litCartelFormID?.id,
        "subCategoryId":
            maintainResourceList.records![index].litmProductSubCategoryID?.id,
        "cartelFormatName":
            maintainResourceList.records![index].litCartelFormID?.identifier,
        "location": maintainResourceList.records![index].locationComment,
        "observation": maintainResourceList.records![index].name,
        "SerNo": maintainResourceList.records![index].serNo,
        "barcode": maintainResourceList.records![index].prodCode,
        "manufacturer": maintainResourceList.records![index].manufacturer,
        "year": maintainResourceList.records![index].manufacturedYear != null
            ? maintainResourceList.records![index].manufacturedYear.toString()
            : "0",
        "Description": maintainResourceList.records![index].description,
        "date3": maintainResourceList.records![index].lITControl3DateFrom,
        "date2": maintainResourceList.records![index].lITControl2DateFrom,
        "date1": maintainResourceList.records![index].lITControl1DateFrom,
        "offlineid": maintainResourceList.records![index].offlineId,
        "length": maintainResourceList.records![index].length,
        "width": maintainResourceList.records![index].width,
        "weightAmt": maintainResourceList.records![index].weightAmt,
        "height": maintainResourceList.records![index].height,
        "color": maintainResourceList.records![index].color,
        "resourceStatus":
            maintainResourceList.records![index].resourceStatus?.id ?? "OUT",
        "resourceGroup":
            maintainResourceList.records![index].litResourceGroupID?.id,
        "note": maintainResourceList.records![index].note,
        "name": maintainResourceList.records![index].name,
        "lot": maintainResourceList.records![index].lot,
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      throw Exception("Failed to get product category");
    }

    //print(list[0].eMail);

    //print(json.);
  }

  Future<String> getPerm(String type) async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/reflistresourcetypecategory.json');
    _tt = RefListResourceTypeJson.fromJson(jsonDecode(file.readAsStringSync()));
    for (var i = 0; i < _tt.records!.length; i++) {
      if (_tt.records![i].value == type) {
        return _tt.records![i].parameterValue!;
      }
    }
    return "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN";
  }

  searchMaintainResource(String barcode) async {
    dataAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/mp_maintain_resource?\$filter= ProdCode eq \'$barcode\'');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      var jsondecoded = jsonDecode(response.body);

      maintainResourceList = WorkOrderResourceLocalJson.fromJson(jsondecoded);
      if (maintainResourceList.records!.isNotEmpty) {
        dataAvailable.value = true;
      }
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  switchMaintainResource(int id) async {
    var msg = {
      "MP_Maintain_ID": {"id": int.parse(toMaintainId.value)}
    };

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url =
        Uri.parse('$protocol://$ip/api/v1/models/mp_maintain_resource/$id');

    var response = await http.put(
      url,
      body: jsonEncode(msg),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      dataAvailable.value = false;
      barcodeSearch.text = "";
      myFocusNode.requestFocus();

      Get.snackbar(
        "Done!".tr,
        "Product Unloaded".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );

      //print(response.body);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    myFocusNode = FocusNode();
  }

  /* void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  } */

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
      projectName: "Logistica",
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

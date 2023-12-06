part of dashboard;

class PurchaseRequestCreationController extends GetxController {
  PriceListJson _trx = PriceListJson(records: []);

  TextEditingController searchFieldController = TextEditingController();
  TextEditingController qtyFieldController = TextEditingController();

  var dataAvailable = false.obs;

  var filterCount = 0.obs;

  List<ProductCheckout2> productList = [];

  var counter = 0.obs;

  var prodListAvailable = true.obs;

  var docTypeId = 0;
  var priceListId = 0;

  @override
  void onInit() {
    super.onInit();
    getDocTypeID();
    getPriceListID();
    getAllProducts(null);
  }

  updateCounter() {
    counter.value = productList.length;
  }

  Future<void> getAllProducts(BuildContext? context) async {
    dataAvailable.value = false;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/lit_mobile_product_v?\$filter= ${searchFieldController.text == '' ? '' : "(contains(tolower(Name),'${searchFieldController.text}') or Value eq '${searchFieldController.text}') and "} AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(utf8.decode(response.bodyBytes));

      _trx = PriceListJson.fromJson(jsondecoded);

      if (_trx.records!.length == 1) {
        openSelectedDialog(context!);
      }

      dataAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  openSelectedDialog(BuildContext context) {
    qtyFieldController.text = '1';
    Get.defaultDialog(
      title: _trx.records![0].name ?? 'N/A',
      onConfirm: () {
        if (double.tryParse(qtyFieldController.text) != null) {
          productList.add(ProductCheckout2(
              id: _trx.records![0].id!,
              name: _trx.records![0].name!,
              qty: double.parse(qtyFieldController.text),
              uom: _trx.records![0].uom,
              cost: 0.0));
          updateCounter();
          Get.back();
        }
      },
      content: Column(
        children: [
          Divider(),
          Container(
            width: 100,
            margin: const EdgeInsets.all(10),
            child: TextField(
              controller: qtyFieldController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                //prefixIcon: const Icon(EvaIcons.search),
                prefixText: _trx.records![0].uom,
                labelText: 'Qty'.tr,
                isDense: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createPurchaseRequest(BuildContext context) async {
    Get.back();
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://$ip/api/v1/windows/requisition');

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    //print(formattedDate);
    List<Map<String, Object>> list = [];

    for (var element in productList) {
      list.add({
        "M_Product_ID": {"id": element.id},
        "qtyEntered": element.qty
      });
    }

    var msg = jsonEncode({
      "AD_Org_ID": {"id": GetStorage().read("organizationid")},
      "AD_Client_ID": {"id": GetStorage().read("clientid")},
      "M_Warehouse_ID": {"id": GetStorage().read("warehouseid")},
      'C_DocType_ID': {'id': docTypeId},
      'DateDoc': formattedDate,
      'DateRequired': formattedDate,
      'PriorityRule': '5',
      'AD_User_ID': {"id": GetStorage().read("userId")},
      'M_PriceList_ID': {'id': priceListId},
      "requisition-line".tr: list,
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Creating record..".tr),
            ],
          ),
        );
      },
    );

    var response = await http.post(
      url,
      body: msg,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );
    Get.back();
    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));

      Get.find<PurchaseRequestController>().getPurchaseRequests();
      Get.back();
      //print("done!");
      Get.snackbar(
        "${json["DocumentNo"]}",
        "The record has been created".tr,
        icon: const Icon(
          Icons.done,
          color: Colors.green,
        ),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
        Get.snackbar(
          "Error!".tr,
          "Record not updated".tr,
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> getDocTypeID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/C_DocType?\$filter= Name eq \'Purchase Requisition\' and  AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(utf8.decode(response.bodyBytes));

      var json = DocumentTypeJSON.fromJson(jsondecoded);

      docTypeId = json.records![0].id!;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getPriceListID() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ${GetStorage().read('token')}';
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse(
        '$protocol://$ip/api/v1/models/AD_SysConfig?\$filter= Name eq \'LIT_Woocommerce_PriceList_ID\' and  AD_Client_ID eq ${GetStorage().read('clientid')}&\$orderby= Name');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);
      var jsondecoded = jsonDecode(utf8.decode(response.bodyBytes));

      var json = ProductJson.fromJson(jsondecoded);

      priceListId = int.parse(json.records![0].value!);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

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
      projectName: "Acquisti",
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

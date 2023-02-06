part of dashboard;

class PortalMpSalesOrderB2BController extends GetxController {
  var prodCategoriesAvailable = false.obs;
  var productsAvailable = false.obs;
  var productDetailAvailable = false.obs;
  var productFilterAvailable = false.obs;

  TextEditingController searchFieldController = TextEditingController();

  B2BProductCategoryJson prodCategories = B2BProductCategoryJson(records: []);

  ProductListJson filteredProds = ProductListJson(records: []);

  ProductJson prodDetail = ProductJson(records: []);

  var detailIndex = 0;
  var detailImage = "";
  var detailImageType = "URL";
  var chosenDetailSize = "".obs;

  var chosenCategoryName = "".obs;
  var chosenProductName = "".obs;

  var cat = 0;

  var colorUrlFilter = "";
  var sizeUrlFilter = "";

  static final List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();

  List<Animal> _selectedAnimals2 = [];

  // FILTER COLOR

  List<FilterColor> _colors = [];
  List<MultiSelectItem<dynamic>> _colorItems = [];

  List<dynamic> _selectedColors = [];

  //END FILTER COLOR
  // FILTER SIZE
  List<FilterSize> _sizes = [];
  List<MultiSelectItem<dynamic>> _sizeItems = [];

  List<dynamic> _selectedSizes = [];

  @override
  void onInit() {
    chosenDetailSize.value;
    super.onInit();
    getProductCategories();
  }

  getProductCategories() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_prod_category_v?\$filter= IsSummary eq Y and IsSelfService eq Y');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      prodCategories = B2BProductCategoryJson.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
      prodCategoriesAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts(int id) async {
    prodCategoriesAvailable.value = false;
    productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= M_Product_Category_ID eq $id');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      for (var record in filteredProds.records!) {
        //color filter
        if (_colors.isEmpty && record.adPrintColorID != null) {
          _colors.add(FilterColor(
              id: record.adPrintColorID!.id!,
              name: record.adPrintColorID!.identifier!));
        }
        if (_colors.isNotEmpty && record.adPrintColorID != null) {
          var found = _colors
              .where((element) => element.id == record.adPrintColorID!.id);
          if (found.isEmpty) {
            _colors.add(FilterColor(
                id: record.adPrintColorID!.id!,
                name: record.adPrintColorID!.identifier!));
          }
        }
        _colorItems = _colors
            .map((color) => MultiSelectItem<FilterColor>(color, color.name))
            .toList();

        //end color filter
        //size filter
        if (_sizes.isEmpty && record.litProductSizeID != null) {
          _sizes.add(FilterSize(
              id: record.litProductSizeID!.id!,
              name: record.litProductSizeID!.identifier!));
        }
        if (_sizes.isNotEmpty && record.litProductSizeID != null) {
          var found = _sizes
              .where((element) => element.id == record.litProductSizeID!.id);
          if (found.isEmpty) {
            _sizes.add(FilterSize(
                id: record.litProductSizeID!.id!,
                name: record.litProductSizeID!.identifier!));
          }
        }
        _sizeItems = _sizes
            .map((size) => MultiSelectItem<FilterSize>(size, size.name))
            .toList();

        //end size filter
      }
      //print(_sizeItems);
      productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts2(int id) async {
    //print("kek");
    prodCategoriesAvailable.value = false;
    //productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= M_Product_Category_ID eq $id $colorUrlFilter $sizeUrlFilter');

    /* print('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= M_Product_Category_ID eq $id $colorUrlFilter $sizeUrlFilter'); */

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  getFilteredProducts3() async {
    //print("kek");
    prodCategoriesAvailable.value = false;
    //productFilterAvailable.value = false;
    productsAvailable.value = false;
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= contains(tolower(value),\'${searchFieldController.text}\')');

    /* print('$protocol://' +
        ip +
        '/api/v1/models/lit_product_list_v?\$filter= M_Product_Category_ID eq $id $colorUrlFilter $sizeUrlFilter'); */

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(utf8.decode(response.bodyBytes));
      filteredProds =
          ProductListJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      //productFilterAvailable.value = true;
      productsAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(utf8.decode(response.bodyBytes));
      }
    }
  }

  Future<void> getProduct(int id) async {
    productFilterAvailable.value = false;
    productDetailAvailable.value = false;

    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= M_Product_ID eq $id');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      prodDetail =
          ProductJson.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      productDetailAvailable.value = true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  //print(list[0].eMail);

  //print(json.);

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
      projectName: "Customer Portal".tr,
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

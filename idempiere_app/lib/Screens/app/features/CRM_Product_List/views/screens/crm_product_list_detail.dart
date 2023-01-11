import 'dart:convert';
//import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/models/productcheckout.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/views/screens/crm_sales_order_creation_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts_Create_Contract/views/screens/crm_maintenance_mpcontacts_create_contract_screen.dart';
import 'package:idempiere_app/Screens/app/shared_components/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'package:idempiere_app/constants.dart';

import '../../../Maintenance_Mptask_resource/models/product_json.dart';

class ProductListDetail extends StatefulWidget {
  const ProductListDetail({Key? key}) : super(key: key);

  @override
  State<ProductListDetail> createState() => _ProductListDetailState();
}

class _ProductListDetailState extends State<ProductListDetail>
    with TickerProviderStateMixin {
  Future<void> getProduct() async {
    final ip = GetStorage().read('ip');
    String authorization = 'Bearer ' + GetStorage().read('token');
    final protocol = GetStorage().read('protocol');
    var url = Uri.parse('$protocol://' +
        ip +
        '/api/v1/models/m_product?\$filter= M_Product_ID eq ${args["id"]}');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      //print(response.body);

      var json = ProductJson.fromJson(jsonDecode(response.body));
      prodId = json.records![0].id!;
      valueFieldController.text = json.records![0].value;
      nameFieldController.text = json.records![0].name;
      descriptionFieldController.text = json.records![0].description ?? "";
      if (json.records![0].discontinued != true) {
        setState(() {
          flagAvailable = true;
        });
      }
      setState(() {
        flagVisible = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }

    //print(list[0].eMail);

    //print(json.);
  }

  dynamic args = Get.arguments;

  // ignore: prefer_typing_uninitialized_variables
  var nameFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var valueFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var descriptionFieldController;
  // ignore: prefer_typing_uninitialized_variables
  var helpFieldController;

  // ignore: prefer_typing_uninitialized_variables
  var flagAvailable;
  // ignore: prefer_typing_uninitialized_variables
  var flagVisible;

  // ignore: prefer_typing_uninitialized_variables
  late TabController imagesController;

  int quantity = 1;
  int prodId = 0;
  num cost = 0;
  double discountedCost = 0;
  double discount = 0;

  @override
  void initState() {
    flagVisible = false;
    flagAvailable = false;
    quantity = 1;
    super.initState();
    cost = args["priceStd"] ?? 0;
    imagesController = TabController(length: 3, vsync: this);
    nameFieldController = TextEditingController();
    valueFieldController = TextEditingController();
    descriptionFieldController = TextEditingController();
    helpFieldController = TextEditingController();
    getProduct();
  }
  //late List<Records> salesrepRecord;
  //bool isSalesRepLoading = false;

  @override
  Widget build(BuildContext context) {
    //getSalesRepAutoComplete();
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product Detail'.tr),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return _buildProductDetailsPage(context);
          },
          tabletBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Value'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: descriptionFieldController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: helpFieldController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Help',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: flagVisible,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: flagAvailable
                            ? Text("Available".tr)
                            : Text("Not Available".tr),
                        style: ButtonStyle(
                          backgroundColor: flagAvailable
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.red),
                        ),
                      )),
                ),
              ],
            );
          },
          desktopBuilder: (context, constraints) {
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: valueFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Value'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: nameFieldController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Name'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: descriptionFieldController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Description'.tr,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    readOnly: true,
                    controller: helpFieldController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Help',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Visibility(
                  visible: flagVisible,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: flagAvailable
                            ? Text("Available".tr)
                            : Text("Not Available".tr),
                        style: ButtonStyle(
                          backgroundColor: flagAvailable
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.red),
                        ),
                      )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetailsPage(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductImagesWidgets(),
                  _buildProductTitleWidget(),
                  const SizedBox(height: 12.0),
                  _buildPriceWidgets(),
                  const SizedBox(height: 12.0),
                  _buildDivider(screenSize),
                  const SizedBox(height: 12.0),
                  _buildFurtherInfoWidget(),
                  const SizedBox(height: 12.0),
                  _buildDivider(screenSize),
                  const SizedBox(height: 12.0),
                  /* _buildSizeChartWidgets(),
                  SizedBox(height: 12.0), */
                  _buildDetailsAndMaterialWidgets(),
                  const SizedBox(height: 12.0),
                  /* _buildStyleNoteHeader(), */
                  const SizedBox(height: 6.0),
                  _buildDivider(screenSize),
                  const SizedBox(height: 4.0),
                  /* _buildStyleNoteData(),
                  SizedBox(height: 20.0), */
                  _buildMoreInfoHeader(),
                  const SizedBox(height: 6.0),
                  _buildDivider(screenSize),
                  const SizedBox(height: 4.0),
                  _buildMoreInfoData(),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  _buildProductImagesWidgets() {
    TabController imagesController = TabController(length: 3, vsync: this);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: 3,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  controller: imagesController,
                  children: <Widget>[
                    Image.network(
                      "https://assets.myntassets.com/h_240,q_90,w_180/v1/assets/images/1304671/2016/4/14/11460624898615-Hancock-Men-Shirts-8481460624898035-1_mini.jpg",
                    ),
                    /* Image.memory(
                      const Base64Codec().decode((Get.arguments["image64"])
                          .replaceAll(RegExp(r'\n'), '')),
                      fit: BoxFit.cover,
                    ), */
                    Image.network(
                      "https://n1.sdlcdn.com/imgs/c/9/8/Lambency-Brown-Solid-Casual-Blazers-SDL781227769-1-1b660.jpg",
                    ),
                    Image.network(
                      "https://images-na.ssl-images-amazon.com/images/I/71O0zS0DT0L._UX342_.jpg",
                    ),
                  ],
                ),
                Container(
                  alignment: const FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildProductTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Center(
        child: Text(
          //name,
          nameFieldController.text,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  _buildPriceWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "€$cost",
            style: const TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Text(
            "€1299",
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Text(
            "30% Off",
            style: TextStyle(
              fontSize: 12.0,
              color: kNotifColor,
            ),
          ),
        ],
      ),
    );
  }

  _buildFurtherInfoWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            //Icons.local_offer,
            Icons.shopping_cart,
            color: Colors.white,
          ),
          const SizedBox(
            width: 30.0,
          ),
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "minus",
                backgroundColor: kPrimaryColor,
                mini: true,
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity = quantity - 1;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            "$quantity",
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "plus",
                backgroundColor: kPrimaryColor,
                mini: true,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    quantity = quantity + 1;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            width: 30.0,
          ),
          Visibility(
            visible: flagVisible,
            child: ElevatedButton(
              onPressed: () {
                if (flagAvailable) {
                  ProductCheckout prod = ProductCheckout(
                      id: prodId,
                      name: nameFieldController
                          .text, //MaintenanceMpContractsCreateContractController
                      qty: quantity,
                      cost: cost);
                  switch (Get.arguments["page"]) {
                    case null:
                      Get.find<CRMSalesOrderCreationController>()
                          .productList
                          .add(prod);
                      Get.find<CRMSalesOrderCreationController>()
                          .updateCounter();
                      Get.find<CRMSalesOrderCreationController>().updateTotal();
                      break;
                    case "createContract":
                      Get.find<MaintenanceMpContractsCreateContractController>()
                          .productList
                          .add(prod);
                      Get.find<MaintenanceMpContractsCreateContractController>()
                          .updateCounter();
                      Get.find<MaintenanceMpContractsCreateContractController>()
                          .updateTotal();
                      break;
                    default:
                      Get.find<CRMSalesOrderCreationController>()
                          .productList
                          .add(prod);
                      Get.find<CRMSalesOrderCreationController>()
                          .updateCounter();
                      Get.find<CRMSalesOrderCreationController>().updateTotal();
                  }
                }
              },
              child: flagAvailable
                  ? Text("Add to Basket".tr)
                  : Text("Not Available".tr),
              style: ButtonStyle(
                backgroundColor: flagAvailable
                    ? MaterialStateProperty.all(Colors.green)
                    : MaterialStateProperty.all(Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* _buildSizeChartWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.straighten,
                color: Colors.grey[600],
              ),
              const SizedBox(
                width: 12.0,
              ),
              Text(
                "Size",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            "SIZE CHART",
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  } */

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = TabController(length: 2, vsync: this);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: tabController,
          tabs: const <Widget>[
            Tab(
              child: Text(
                "DETAILS",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                "MATERIAL & CARE",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          height: 50.0,
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              Text(
                descriptionFieldController.text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const Text(
                "86% acrylic, 9% polyster, 1% metallic yarn Hand-wash cold",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /* _buildStyleNoteHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "STYLE NOTE",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _buildStyleNoteData() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "Boys dress",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  } */

  _buildMoreInfoHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
      ),
      child: Text(
        "MORE INFO",
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  _buildMoreInfoData() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        bottom: 12.0,
      ),
      child: Text(
        "Product Code: ${valueFieldController.text}\nTax info: Applicable GST will be charged at the time of chekout",
        style: TextStyle(
          color: Colors.grey[500],
        ),
      ),
    );
  }

  /* _buildBottomNavigationBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.grey,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.list,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: RaisedButton(
              onPressed: () {},
              color: Colors.greenAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.card_travel,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "ADD TO BAG",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } */
}

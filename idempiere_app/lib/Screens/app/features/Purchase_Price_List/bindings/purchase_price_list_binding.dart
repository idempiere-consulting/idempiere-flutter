part of dashboard;

class PurchasePriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchasePriceListController());
  }
}

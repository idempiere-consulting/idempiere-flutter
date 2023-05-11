part of dashboard;

class PurchaseProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseProductListController());
  }
}

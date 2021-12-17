part of dashboard;

class PurchaseOrderpoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseOrderpoController());
  }
}

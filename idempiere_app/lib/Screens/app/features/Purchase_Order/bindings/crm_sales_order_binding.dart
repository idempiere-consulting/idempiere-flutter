part of dashboard;

class PurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseOrderController());
  }
}

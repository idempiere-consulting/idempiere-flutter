part of dashboard;

class PurchaseRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseRequestController());
  }
}

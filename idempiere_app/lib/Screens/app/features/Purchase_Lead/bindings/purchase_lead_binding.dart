part of dashboard;

class PurchaseLeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseLeadController());
  }
}

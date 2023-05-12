part of dashboard;

class PurchaseContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseContractController());
  }
}

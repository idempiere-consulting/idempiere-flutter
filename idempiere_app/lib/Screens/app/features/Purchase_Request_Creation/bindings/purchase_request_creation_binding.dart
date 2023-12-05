part of dashboard;

class PurchaseRequestCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseRequestCreationController());
  }
}

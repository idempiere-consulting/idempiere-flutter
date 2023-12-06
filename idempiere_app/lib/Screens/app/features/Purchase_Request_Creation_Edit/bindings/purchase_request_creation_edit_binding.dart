part of dashboard;

class PurchaseRequestCreationEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseRequestCreationEditController());
  }
}

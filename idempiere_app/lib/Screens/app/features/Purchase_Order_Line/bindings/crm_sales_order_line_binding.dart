part of dashboard;

class CRMPurchaseOrderLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMPurchaseOrderLineController());
  }
}

part of dashboard;

class CRMPurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMPurchaseOrderController());
  }
}

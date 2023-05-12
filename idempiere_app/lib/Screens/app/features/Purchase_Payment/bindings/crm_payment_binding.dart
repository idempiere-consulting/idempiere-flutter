part of dashboard;

class PurchasePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchasePaymentController());
  }
}

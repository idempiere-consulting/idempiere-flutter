part of dashboard;

class CRMPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMPaymentController());
  }
}

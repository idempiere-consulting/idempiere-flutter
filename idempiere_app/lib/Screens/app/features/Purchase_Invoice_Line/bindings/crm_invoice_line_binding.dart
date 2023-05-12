part of dashboard;

class CRMInvoicePOLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMInvoicePOLineController());
  }
}

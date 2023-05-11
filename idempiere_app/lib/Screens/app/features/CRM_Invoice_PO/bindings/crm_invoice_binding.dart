part of dashboard;

class CRMInvoicePOBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMInvoicePOController());
  }
}

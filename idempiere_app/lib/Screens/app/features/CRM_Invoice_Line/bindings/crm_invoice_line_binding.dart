part of dashboard;

class CRMInvoiceLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMInvoiceLineController());
  }
}

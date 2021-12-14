part of dashboard;

class CRMInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMInvoiceController());
  }
}

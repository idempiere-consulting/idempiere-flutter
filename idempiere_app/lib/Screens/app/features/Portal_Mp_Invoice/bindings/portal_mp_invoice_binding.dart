part of dashboard;

class PortalMpInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpInvoiceController());
  }
}

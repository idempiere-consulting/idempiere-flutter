part of dashboard;

class PortalMpInvoicepoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpInvoicepoController());
  }
}

part of dashboard;

class MaintenanceInvoicepoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceInvoicepoController());
  }
}

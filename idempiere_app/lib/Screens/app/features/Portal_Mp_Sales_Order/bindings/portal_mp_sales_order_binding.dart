part of dashboard;

class PortalMpSalesOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpSalesOrderController());
  }
}

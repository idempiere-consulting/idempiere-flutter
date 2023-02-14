part of dashboard;

class PortalMpSalesOrderB2BBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpSalesOrderB2BController());
  }
}

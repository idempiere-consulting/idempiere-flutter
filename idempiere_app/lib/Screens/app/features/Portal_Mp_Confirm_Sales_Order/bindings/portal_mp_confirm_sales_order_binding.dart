part of dashboard;

class PortalMpConfirmSalesOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpConfirmSalesOrderController());
  }
}

part of dashboard;

class PortalMpSalesOrderFromPriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpSalesOrderFromPriceListController());
  }
}

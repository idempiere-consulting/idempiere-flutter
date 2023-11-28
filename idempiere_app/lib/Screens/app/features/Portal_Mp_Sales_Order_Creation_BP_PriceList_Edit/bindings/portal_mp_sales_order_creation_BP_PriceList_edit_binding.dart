part of dashboard;

class PortalMpSalesOrderCreationBPPriceListEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpSalesOrderCreationBPPriceListEditController());
  }
}

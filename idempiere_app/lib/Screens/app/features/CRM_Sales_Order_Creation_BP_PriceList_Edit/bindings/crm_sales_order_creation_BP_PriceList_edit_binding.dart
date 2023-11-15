part of dashboard;

class CRMSalesOrderCreationBPPriceListEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderCreationBPPriceListEditController());
  }
}

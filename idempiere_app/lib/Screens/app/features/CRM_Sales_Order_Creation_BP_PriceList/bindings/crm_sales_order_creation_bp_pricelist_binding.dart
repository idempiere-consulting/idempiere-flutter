part of dashboard;

class CRMSalesOrderCreationBPPricelistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderCreationBPPricelistController());
  }
}

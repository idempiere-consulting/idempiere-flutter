part of dashboard;

class CRMSalesOrderCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderCreationController());
  }
}

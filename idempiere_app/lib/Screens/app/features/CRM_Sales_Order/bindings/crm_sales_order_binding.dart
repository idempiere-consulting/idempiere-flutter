part of dashboard;

class CRMSalesOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderController());
  }
}

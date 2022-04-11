part of dashboard;

class CRMSalesOrderLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderLineController());
  }
}

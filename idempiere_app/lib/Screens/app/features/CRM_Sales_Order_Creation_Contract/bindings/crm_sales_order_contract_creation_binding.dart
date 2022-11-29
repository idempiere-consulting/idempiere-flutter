part of dashboard;

class CRMSalesOrderContractCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMSalesOrderContractCreationController());
  }
}

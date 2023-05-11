part of dashboard;

class CRMContractCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContractCustomerController());
  }
}

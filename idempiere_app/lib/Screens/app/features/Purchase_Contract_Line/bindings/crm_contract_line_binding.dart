part of dashboard;

class CRMContractCustomerLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContractCustomerLineController());
  }
}

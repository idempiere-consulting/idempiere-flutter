part of dashboard;

class CRMContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContractController());
  }
}

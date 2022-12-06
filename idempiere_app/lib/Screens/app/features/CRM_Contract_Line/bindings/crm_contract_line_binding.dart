part of dashboard;

class CRMContractLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContractLineController());
  }
}

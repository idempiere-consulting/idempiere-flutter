part of dashboard;

class CRMLeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMLeadController());
  }
}

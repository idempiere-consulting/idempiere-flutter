part of dashboard;

class CRMBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMController());
  }
}

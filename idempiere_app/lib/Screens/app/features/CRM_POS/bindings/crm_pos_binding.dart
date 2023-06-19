part of dashboard;

class CRMPOSBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMPOSController());
  }
}

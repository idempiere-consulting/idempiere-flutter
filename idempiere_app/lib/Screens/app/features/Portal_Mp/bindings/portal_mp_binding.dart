part of dashboard;

class PortalMpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpController());
  }
}

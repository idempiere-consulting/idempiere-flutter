part of dashboard;

class PortalMpPortalofferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpPortalofferController());
  }
}

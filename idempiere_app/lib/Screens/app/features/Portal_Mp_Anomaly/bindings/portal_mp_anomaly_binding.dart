part of dashboard;

class PortalMpAnomalyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpAnomalyController());
  }
}

part of dashboard;

class PortalMpMaintenanceMptaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpMaintenanceMptaskController());
  }
}

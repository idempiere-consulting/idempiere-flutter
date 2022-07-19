part of dashboard;

class PortalMpMaintenanceMpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpMaintenanceMpController());
  }
}

part of dashboard;

class MaintenanceMpResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpResourceController());
  }
}

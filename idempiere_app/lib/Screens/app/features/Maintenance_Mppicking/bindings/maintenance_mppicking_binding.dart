part of dashboard;

class MaintenanceMppickingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMppickingController());
  }
}

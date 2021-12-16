part of dashboard;

class MaintenanceMptaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMptaskController());
  }
}

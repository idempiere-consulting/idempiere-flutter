part of dashboard;

class MaintenanceMptaskLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMptaskLineController());
  }
}

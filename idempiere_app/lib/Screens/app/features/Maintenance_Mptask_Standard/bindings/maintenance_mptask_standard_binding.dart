part of dashboard;

class MaintenanceMptaskStandardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMptaskStandardController());
  }
}

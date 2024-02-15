part of dashboard;

class MaintenanceStandardMptaskLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceStandardMptaskLineController());
  }
}

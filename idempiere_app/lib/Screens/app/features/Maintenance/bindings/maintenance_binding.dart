part of dashboard;

class MaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceController());
  }
}

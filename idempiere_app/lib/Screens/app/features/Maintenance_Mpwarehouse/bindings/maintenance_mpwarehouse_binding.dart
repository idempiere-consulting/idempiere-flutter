part of dashboard;

class MaintenanceMpwarehouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpwarehouseController());
  }
}

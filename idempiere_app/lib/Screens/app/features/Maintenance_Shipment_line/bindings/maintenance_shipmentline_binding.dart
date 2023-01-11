part of dashboard;

class MaintenanceShipmentlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceShipmentlineController());
  }
}

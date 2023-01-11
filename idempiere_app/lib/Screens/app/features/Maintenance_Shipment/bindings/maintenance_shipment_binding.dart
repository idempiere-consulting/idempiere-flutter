part of dashboard;

class MaintenanceShipmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceShipmentController());
  }
}

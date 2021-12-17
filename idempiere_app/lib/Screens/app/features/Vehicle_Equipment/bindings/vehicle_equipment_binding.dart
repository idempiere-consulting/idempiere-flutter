part of dashboard;

class VehicleEquipmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleEquipmentController());
  }
}

part of dashboard;

class VehicleEquipmentEquipmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleEquipmentEquipmentController());
  }
}

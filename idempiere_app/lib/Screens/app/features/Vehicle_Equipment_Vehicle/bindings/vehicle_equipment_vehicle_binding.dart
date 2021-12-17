part of dashboard;

class VehicleEquipmentVehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleEquipmentVehicleController());
  }
}

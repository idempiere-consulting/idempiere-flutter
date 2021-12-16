part of dashboard;

class MaintenanceMpanomalyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpanomalyController());
  }
}

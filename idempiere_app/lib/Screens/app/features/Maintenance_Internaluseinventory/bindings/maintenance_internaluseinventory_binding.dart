part of dashboard;

class MaintenanceInternaluseinventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceInternaluseinventoryController());
  }
}

part of dashboard;

class MaintenanceMpResourceSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpResourceSheetController());
  }
}

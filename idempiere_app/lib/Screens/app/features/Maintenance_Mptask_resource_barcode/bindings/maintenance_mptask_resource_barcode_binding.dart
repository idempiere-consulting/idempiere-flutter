part of dashboard;

class MaintenanceMpResourceBarcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpResourceBarcodeController());
  }
}

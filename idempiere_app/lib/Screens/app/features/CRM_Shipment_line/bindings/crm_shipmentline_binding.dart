part of dashboard;

class CRMShipmentlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMShipmentlineController());
  }
}

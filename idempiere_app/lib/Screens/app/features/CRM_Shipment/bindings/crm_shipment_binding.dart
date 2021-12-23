part of dashboard;

class CRMShipmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMShipmentController());
  }
}

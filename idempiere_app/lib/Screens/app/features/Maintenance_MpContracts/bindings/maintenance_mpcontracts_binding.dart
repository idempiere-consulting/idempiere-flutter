part of dashboard;

class MaintenanceMpContractsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpContractsController());
  }
}

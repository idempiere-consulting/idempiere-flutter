part of dashboard;

class SupplychainMaintenanceSwitchResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainMaintenanceSwitchResourceController());
  }
}

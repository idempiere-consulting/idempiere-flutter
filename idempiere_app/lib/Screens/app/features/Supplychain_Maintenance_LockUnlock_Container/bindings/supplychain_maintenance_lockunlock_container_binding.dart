part of dashboard;

class SupplychainMaintenanceLockUnlockContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainMaintenanceLockUnlockContainerController());
  }
}

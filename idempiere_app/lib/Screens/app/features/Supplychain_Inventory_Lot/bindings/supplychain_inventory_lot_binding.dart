part of dashboard;

class SupplychainInventoryLotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainInventoryLotController());
  }
}

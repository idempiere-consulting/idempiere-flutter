part of dashboard;

class SupplychainInventoryLotLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainInventoryLotLineController());
  }
}

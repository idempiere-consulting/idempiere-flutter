part of dashboard;

class SupplychainInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainInventoryController());
  }
}

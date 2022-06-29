part of dashboard;

class SupplychainInventoryLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainInventoryLineController());
  }
}

part of dashboard;

class SupplychainProductwarehouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainProductwarehouseController());
  }
}

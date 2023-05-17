part of dashboard;

class SupplychainProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainProductListController());
  }
}

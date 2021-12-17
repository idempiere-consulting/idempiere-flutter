part of dashboard;

class SupplychainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainController());
  }
}

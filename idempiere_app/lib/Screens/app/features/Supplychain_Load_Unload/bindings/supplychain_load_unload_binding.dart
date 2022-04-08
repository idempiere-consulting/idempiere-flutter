part of dashboard;

class SupplychainLoadUnloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainLoadUnloadController());
  }
}

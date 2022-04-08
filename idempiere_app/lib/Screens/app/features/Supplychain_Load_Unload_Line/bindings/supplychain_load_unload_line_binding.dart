part of dashboard;

class SupplychainLoadUnloadLineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainLoadUnloadLineController());
  }
}

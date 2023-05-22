part of dashboard;

class SupplychainMaterialreceiptCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainMaterialreceiptCreationController());
  }
}

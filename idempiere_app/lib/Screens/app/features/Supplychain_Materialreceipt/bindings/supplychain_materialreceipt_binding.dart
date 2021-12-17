part of dashboard;

class SupplychainMaterialreceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupplychainMaterialreceiptController());
  }
}

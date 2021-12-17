part of dashboard;

class PurchaseProductwarehousepriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseProductwarehousepriceController());
  }
}

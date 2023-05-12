part of dashboard;

class PurchaseInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseInvoiceController());
  }
}

part of dashboard;

class ProductionOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductionOrderController());
  }
}

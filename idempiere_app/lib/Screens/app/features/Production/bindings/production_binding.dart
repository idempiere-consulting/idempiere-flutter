part of dashboard;

class ProductionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductionController());
  }
}

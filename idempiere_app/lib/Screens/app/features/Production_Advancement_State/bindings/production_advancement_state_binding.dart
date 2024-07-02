part of dashboard;

class ProductionAdvancementStateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductionAdvancementStateController());
  }
}

part of dashboard;

class HumanResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HumanResourceController());
  }
}

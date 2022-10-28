part of dashboard;

class AnomalyListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnomalyListController());
  }
}

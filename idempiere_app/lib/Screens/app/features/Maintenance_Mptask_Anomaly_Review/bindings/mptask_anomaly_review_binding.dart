part of dashboard;

class AnomalyReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AnomalyReviewController());
  }
}

part of dashboard;

class CRMListinoProdottiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMListinoProdottiController());
  }
}

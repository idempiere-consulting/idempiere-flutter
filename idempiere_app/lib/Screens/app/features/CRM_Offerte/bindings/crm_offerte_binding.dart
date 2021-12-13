part of dashboard;

class CRMOfferteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMOfferteController());
  }
}

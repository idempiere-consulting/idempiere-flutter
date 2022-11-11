part of dashboard;

class CRMPriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMPriceListController());
  }
}

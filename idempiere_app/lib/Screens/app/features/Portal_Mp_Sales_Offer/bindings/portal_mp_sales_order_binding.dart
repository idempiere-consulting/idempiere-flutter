part of dashboard;

class PortalMpSalesOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpSalesOfferController());
  }
}

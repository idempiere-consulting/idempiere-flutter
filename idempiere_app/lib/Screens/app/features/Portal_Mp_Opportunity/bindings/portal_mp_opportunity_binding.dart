part of dashboard;

class PortalMpOpportunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpOpportunityController());
  }
}

part of dashboard;

class CRMOpportunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMOpportunityController());
  }
}

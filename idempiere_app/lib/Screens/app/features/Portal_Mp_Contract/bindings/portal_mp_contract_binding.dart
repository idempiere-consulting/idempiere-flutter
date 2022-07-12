part of dashboard;

class PortalMpContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpContractController());
  }
}

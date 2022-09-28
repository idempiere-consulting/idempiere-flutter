part of dashboard;

class MaintenanceMpContractsCreateContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpContractsCreateContractController());
  }
}

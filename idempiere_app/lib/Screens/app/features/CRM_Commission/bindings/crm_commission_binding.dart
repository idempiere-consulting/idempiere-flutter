part of dashboard;

class CRMCommissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMCommissionController());
  }
}

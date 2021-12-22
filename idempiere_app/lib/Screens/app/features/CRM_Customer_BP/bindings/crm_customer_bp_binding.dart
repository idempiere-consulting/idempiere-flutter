part of dashboard;

class CRMCustomerBpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMCustomerBpController());
  }
}

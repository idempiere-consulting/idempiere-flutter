part of dashboard;

class CRMCustomerBPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMCustomerBPController());
  }
}

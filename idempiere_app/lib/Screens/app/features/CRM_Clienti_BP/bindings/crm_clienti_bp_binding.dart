part of dashboard;

class CRMClientiBPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMClientiBPController());
  }
}

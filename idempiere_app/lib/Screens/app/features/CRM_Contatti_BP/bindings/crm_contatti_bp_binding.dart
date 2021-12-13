part of dashboard;

class CRMContattiBPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContattiBPController());
  }
}

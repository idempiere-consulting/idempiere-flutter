part of dashboard;

class CRMOpenItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMOpenItemsController());
  }
}

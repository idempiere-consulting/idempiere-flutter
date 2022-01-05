part of dashboard;

class CRMProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMProductListController());
  }
}

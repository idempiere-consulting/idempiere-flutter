part of dashboard;

class CRMContactBPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMContactBPController());
  }
}

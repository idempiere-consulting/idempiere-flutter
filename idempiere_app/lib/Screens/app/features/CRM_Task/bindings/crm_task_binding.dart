part of dashboard;

class CRMTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMTaskController());
  }
}

part of dashboard;

class CRMTaskAppuntamentiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CRMTaskAppuntamentiController());
  }
}

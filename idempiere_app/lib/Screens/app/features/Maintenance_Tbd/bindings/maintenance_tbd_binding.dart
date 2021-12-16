part of dashboard;

class MaintenanceTbdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceTbdController());
  }
}

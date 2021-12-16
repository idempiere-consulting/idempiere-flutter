part of dashboard;

class MaintenanceMpimportitemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpimportitemController());
  }
}

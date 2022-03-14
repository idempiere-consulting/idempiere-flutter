part of dashboard;

class MaintenanceMpResourceFireExtinguisherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceMpResourceFireExtinguisherController());
  }
}

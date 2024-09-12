part of dashboard;

class PermissionCustomizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PermissionCustomizationController());
  }
}

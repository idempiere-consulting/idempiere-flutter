part of dashboard;

class HumanResourceEmployeeSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HumanResourceEmployeeSheetController());
  }
}

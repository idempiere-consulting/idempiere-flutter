part of dashboard;

class HumanResourceWorkHoursBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HumanResourceWorkHoursController());
  }
}

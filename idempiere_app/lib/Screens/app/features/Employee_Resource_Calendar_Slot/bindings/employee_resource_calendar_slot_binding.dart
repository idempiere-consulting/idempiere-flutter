part of dashboard;

class EmployeeResourceCalendarSlotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeResourceCalendarSlotController());
  }
}

part of dashboard;

class HumanResourceAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HumanResourceAttendanceController());
  }
}

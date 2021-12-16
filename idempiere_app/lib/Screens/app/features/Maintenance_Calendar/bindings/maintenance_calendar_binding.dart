part of dashboard;

class MaintenanceCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MaintenanceCalendarController());
  }
}

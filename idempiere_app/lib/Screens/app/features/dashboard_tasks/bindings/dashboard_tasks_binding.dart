part of dashboard;

class DashboardTasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardTasksController());
  }
}

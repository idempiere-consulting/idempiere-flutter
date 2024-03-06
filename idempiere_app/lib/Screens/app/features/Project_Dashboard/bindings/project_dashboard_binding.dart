part of dashboard;

class ProjectDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectDashboardController());
  }
}

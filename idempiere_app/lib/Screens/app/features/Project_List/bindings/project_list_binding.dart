part of dashboard;

class ProjectListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectListController());
  }
}

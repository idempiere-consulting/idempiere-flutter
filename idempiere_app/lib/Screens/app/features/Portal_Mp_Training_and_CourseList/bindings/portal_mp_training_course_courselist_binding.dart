part of dashboard;

class PortalMpTrainingCourseCourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpTrainingCourseCourseListController());
  }
}

part of dashboard;

class TrainingCourseCourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingCourseCourseListController());
  }
}

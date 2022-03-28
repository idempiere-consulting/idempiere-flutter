part of dashboard;

class TrainingCourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingCourseController());
  }
}

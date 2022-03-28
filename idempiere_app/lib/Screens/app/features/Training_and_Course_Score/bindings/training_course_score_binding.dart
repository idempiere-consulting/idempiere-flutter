part of dashboard;

class TrainingCourseScoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingCourseScoreController());
  }
}

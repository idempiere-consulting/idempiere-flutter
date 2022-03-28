part of dashboard;

class TrainingCourseSurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingCourseSurveyController());
  }
}

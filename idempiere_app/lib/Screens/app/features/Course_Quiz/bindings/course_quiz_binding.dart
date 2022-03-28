part of dashboard;

class CourseQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseQuizController());
  }
}

part of dashboard;

class TrainingCoursePresenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingCoursePresenceController());
  }
}

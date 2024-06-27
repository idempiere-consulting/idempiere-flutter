part of dashboard;

class PortalMpHoursReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalMpHoursReviewController());
  }
}

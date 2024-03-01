part of dashboard;

class DeskDocAttachmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeskDocAttachmentsController());
  }
}

part of dashboard;

class HumanResourceTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HumanResourceTicketController());
  }
}

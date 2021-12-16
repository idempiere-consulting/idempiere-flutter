part of dashboard;

class TicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketController());
  }
}

part of dashboard;

class TicketTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketTicketController());
  }
}

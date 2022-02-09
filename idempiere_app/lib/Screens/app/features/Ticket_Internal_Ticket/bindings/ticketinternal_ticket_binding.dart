part of dashboard;

class TicketInternalTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketInternalTicketController());
  }
}

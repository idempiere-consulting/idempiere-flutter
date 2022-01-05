part of dashboard;

class TicketTicketNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketTicketNewController());
  }
}

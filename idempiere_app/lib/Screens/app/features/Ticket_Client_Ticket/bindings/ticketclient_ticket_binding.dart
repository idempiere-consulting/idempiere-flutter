part of dashboard;

class TicketClientTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketClientTicketController());
  }
}

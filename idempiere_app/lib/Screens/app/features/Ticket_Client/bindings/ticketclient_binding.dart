part of dashboard;

class TicketClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketClientController());
  }
}

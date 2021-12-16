part of dashboard;

class TicketCustomerTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketCustomerTicketController());
  }
}

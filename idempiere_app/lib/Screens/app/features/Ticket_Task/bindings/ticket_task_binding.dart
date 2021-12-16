part of dashboard;

class TicketTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketTaskController());
  }
}

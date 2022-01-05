part of dashboard;

class TicketTaskToDoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketTaskToDoController());
  }
}

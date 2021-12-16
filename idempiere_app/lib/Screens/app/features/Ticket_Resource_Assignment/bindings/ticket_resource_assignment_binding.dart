part of dashboard;

class TicketResourceAssignmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketResourceAssignmentController());
  }
}

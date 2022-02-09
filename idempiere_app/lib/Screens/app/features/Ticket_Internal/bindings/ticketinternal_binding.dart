part of dashboard;

class TicketInternalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketInternalController());
  }
}

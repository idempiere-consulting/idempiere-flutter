part of dashboard;

class EmployeeTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeTicketController());
  }
}

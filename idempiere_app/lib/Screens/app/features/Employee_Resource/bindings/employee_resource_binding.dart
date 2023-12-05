part of dashboard;

class EmployeeResourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeResourceController());
  }
}

part of dashboard;

class AccountingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountingController());
  }
}

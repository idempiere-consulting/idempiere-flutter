part of dashboard;

class AccountingAssetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountingAssetController());
  }
}

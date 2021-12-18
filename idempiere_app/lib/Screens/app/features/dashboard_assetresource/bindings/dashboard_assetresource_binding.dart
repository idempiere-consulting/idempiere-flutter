part of dashboard;

class DashboardAssetresourceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardAssetresourceController());
  }
}

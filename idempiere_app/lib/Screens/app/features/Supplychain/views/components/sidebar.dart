part of dashboard;

class _Sidebar extends StatelessWidget {
  _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

  final List<dynamic> list = GetStorage().read('permission');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(
                data: data,
              ),
            ),
            const Divider(thickness: 1),
            SelectionButton(
              initialSelected: 0,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  label: "SupplychainProductwarehouse".tr,
                  visible: int.parse(list[64], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SupplychainInventory".tr,
                  visible: int.parse(list[73], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SupplychainMaterialreceipt".tr,
                  visible: int.parse(list[66], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Load & Unload".tr,
                  visible: int.parse(list[74], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Inventory with Lot".tr,
                  visible: int.parse(list[74], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.ballot,
                  icon: Icons.ballot_outlined,
                  label: "ProductList".tr,
                  visible: int.parse(list[9], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.ballot,
                  icon: Icons.ballot_outlined,
                  label: "Switch Maintenance Resource".tr,
                  visible: int.parse(list[71], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                //Get.toNamed('/${value.label}');
                switch (index) {
                  case 0:
                    Get.offNamed('/Dashboard');
                    break;

                  case 1:
                    Get.offNamed('/SupplychainProductwarehouse');
                    break;

                  case 2:
                    Get.offNamed('/SupplychainInventory');
                    break;

                  case 3:
                    Get.offNamed('/SupplychainMaterialreceipt');
                    break;
                  case 4:
                    Get.offNamed('/SupplychainLoadUnload');
                    break;
                  case 5:
                    Get.offNamed('/SupplychainInventoryLot');
                    break;
                  case 6:
                    Get.offNamed('/SupplychainProductList');
                    break;
                  case 7:
                    Get.offNamed('/SupplychainMaintenanceSwitchResourceScreen');
                    break;
                  default:
                }
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            /* UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {},
            ), */
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }
}

part of dashboard;

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

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
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  label: "Calendar".tr,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  label: "Email".tr,
                  totalNotif: 20,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.attractions,
                  icon: Icons.attractions_outlined,
                  label: "CRM".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.sell,
                  icon: Icons.sell_outlined,
                  label: "Ticket".tr,
                  visible: true,
                ),
                SelectionButtonData(
                  activeIcon: Icons.build,
                  icon: Icons.build_outlined,
                  label: "Maintenance".tr,
                  visible: true,
                ),
                SelectionButtonData(
                  activeIcon: Icons.dashboard,
                  icon: Icons.dashboard_outlined,
                  label: "PortalMp".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.shopping_cart,
                  icon: Icons.shopping_cart_outlined,
                  label: "Purchase".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_convenience_store,
                  icon: Icons.local_convenience_store_outlined,
                  label: "Supplychain".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.emoji_transportation,
                  icon: Icons.emoji_transportation_outlined,
                  label: "VehicleEquipment".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.real_estate_agent,
                  icon: Icons.real_estate_agent_outlined,
                  label: "DashboardAssetresource".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.personOutline,
                  label: "Profil".tr,
                  visible: false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Setting".tr,
                  visible: false,
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
                    Get.offNamed('/Calendar');
                    break;
                  case 2:
                    Get.offNamed('/Email');
                    break;
                  case 3:
                    Get.offNamed('/CRM');
                    break;
                  case 4:
                    Get.offNamed('/Ticket');
                    break;
                  case 5:
                    Get.offNamed('/Maintenance');
                    break;
                  case 6:
                    Get.offNamed('/PortalMp');
                    break;
                  case 7:
                    Get.offNamed('/Purchase');
                    break;
                  case 8:
                    Get.offNamed('/Supplychain');
                    break;
                  case 9:
                    Get.offNamed('/VehicleEquipment');
                    break;
                  case 10:
                    Get.offNamed('/DashboardAssetresource');
                    break;
                  case 11:
                    Get.offNamed('/Profil');
                    break;
                  case 12:
                    Get.offNamed('/Setting');
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

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
                  label: "Dashboard",
                ),
                SelectionButtonData(
                  activeIcon: Icons.attractions,
                  icon: Icons.attractions_outlined,
                  label: "CRM",
                ),
                SelectionButtonData(
                  activeIcon: Icons.sell,
                  icon: Icons.sell_outlined,
                  label: "Ticket",
                ),
                SelectionButtonData(
                  activeIcon: Icons.build,
                  icon: Icons.build_outlined,
                  label: "Maintenance",
                ),
                SelectionButtonData(
                  activeIcon: Icons.dashboard,
                  icon: Icons.dashboard_outlined,
                  label: "PortalMp",
                ),
                SelectionButtonData(
                  activeIcon: Icons.shopping_cart,
                  icon: Icons.shopping_cart_outlined,
                  label: "Purchase",
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_convenience_store,
                  icon: Icons.local_convenience_store_outlined,
                  label: "Supplychain",
                ),
                SelectionButtonData(
                  activeIcon: Icons.emoji_transportation,
                  icon: Icons.emoji_transportation_outlined,
                  label: "VehicleEquipment",
                ),
                SelectionButtonData(
                  activeIcon: Icons.real_estate_agent,
                  icon: Icons.real_estate_agent_outlined,
                  label: "DashboardAssetresource",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  label: "Calendar",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  label: "Email",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.personOutline,
                  label: "Profil",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Setting",
                ),
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                Get.toNamed('/${value.label}');
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

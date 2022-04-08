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
              initialSelected: 4,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SupplychainProductwarehouse".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SupplychainInventory".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SupplychainMaterialreceipt".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Load & Unload",
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

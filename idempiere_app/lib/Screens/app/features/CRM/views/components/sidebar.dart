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
              initialSelected: 0,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Lead",
                ),
                SelectionButtonData(
                  activeIcon: Icons.paid,
                  icon: Icons.paid_outlined,
                  label: "Opportunity",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Contatti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Clienti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Task&Appuntamenti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Offerte",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "ListinoProdotti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Fattura",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Incassi",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Provvigioni",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: Icons.person_outlined,
                  label: "Magazzino",
                  totalNotif: 20,
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

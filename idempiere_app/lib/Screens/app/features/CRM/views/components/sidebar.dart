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
                  activeIcon: Icons.person_add,
                  icon: EvaIcons.personOutline,
                  label: "Lead",
                ),
                SelectionButtonData(
                  activeIcon: Icons.paid,
                  icon: Icons.paid_outlined,
                  label: "Opportunity",
                ),
                SelectionButtonData(
                  activeIcon: Icons.contact_mail,
                  icon: Icons.contact_mail_outlined,
                  label: "Contatti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.domain,
                  icon: Icons.domain_outlined,
                  label: "Clienti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.task,
                  icon: Icons.task_outlined,
                  label: "Task&Appuntamenti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.description,
                  icon: Icons.description_outlined,
                  label: "Offerte",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.ballot,
                  icon: Icons.ballot_outlined,
                  label: "ListinoProdotti",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.receipt,
                  icon: Icons.receipt_outlined,
                  label: "Fattura",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.payments,
                  icon: Icons.payments_outlined,
                  label: "Incassi",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.request_quote,
                  icon: Icons.request_quote_outlined,
                  label: "Provvigioni",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_shipping,
                  icon: Icons.local_shipping_outlined,
                  label: "Documento di Trasporto",
                  totalNotif: 20,
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
                    Get.offNamed('/Lead');
                    break;
                  case 2:
                    Get.offNamed('/Opportunity');
                    break;
                  case 3:
                    Get.offNamed('/Contatti');
                    break;
                  case 4:
                    Get.offNamed('/clienti');
                    break;
                  case 5:
                    Get.offNamed('/Task&Appuntamenti');
                    break;
                  case 6:
                    Get.offNamed('/Offerte');
                    break;
                  case 7:
                    Get.offNamed('/ListinoProdotti');
                    break;
                  case 8:
                    Get.offNamed('/Fattura');
                    break;
                  case 9:
                    Get.offNamed('/Incassi');
                    break;
                  case 10:
                    Get.offNamed('/Provvigioni');
                    break;
                  case 11:
                    Get.offNamed('/Magazzino');
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

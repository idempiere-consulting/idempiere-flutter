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
              initialSelected: 7,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person_add,
                  icon: EvaIcons.personOutline,
                  label: "Lead".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.paid,
                  icon: Icons.paid_outlined,
                  label: "Opportunity".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.contact_mail,
                  icon: Icons.contact_mail_outlined,
                  label: "ContactBP".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.domain,
                  icon: Icons.domain_outlined,
                  label: "CustomerBP".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.task,
                  icon: Icons.task_outlined,
                  label: "Task".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.description,
                  icon: Icons.description_outlined,
                  label: "SalesOrder".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.ballot,
                  icon: Icons.ballot_outlined,
                  label: "ProductList".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.receipt,
                  icon: Icons.receipt_outlined,
                  label: "Invoice".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.payments,
                  icon: Icons.payments_outlined,
                  label: "Payment".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.request_quote,
                  icon: Icons.request_quote_outlined,
                  label: "Commission".tr,
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_shipping,
                  icon: Icons.local_shipping_outlined,
                  label: "Shipment".tr,
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
                    Get.offNamed('/ContactBP');
                    break;
                  case 4:
                    Get.offNamed('/CustomerBP');
                    break;
                  case 5:
                    Get.offNamed('/Task');
                    break;
                  case 6:
                    Get.offNamed('/SalesOrder');
                    break;
                  case 7:
                    Get.offNamed('/ProductList');
                    break;
                  case 8:
                    Get.offNamed('/Invoice');
                    break;
                  case 9:
                    Get.offNamed('/Payment');
                    break;
                  case 10:
                    Get.offNamed('/Commission');
                    break;
                  case 11:
                    Get.offNamed('/Shipment');
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

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
              initialSelected: 1,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "SalesOrder".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Contract".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Invoice".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Ticket".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Anomaly".tr,
                ),
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                //Get.toNamed('/${value.label}');
                switch (index) {
                  case 0:
                    if ((int.parse(list[32], radix: 16)
                                    .toRadixString(2)
                                    .padLeft(8, "0")
                                    .toString()[4] ==
                                "1" &&
                            (int.parse(list[32], radix: 16)
                                        .toRadixString(2)
                                        .padLeft(8, "0")
                                        .toString()[5] ==
                                    "1" ||
                                int.parse(list[32], radix: 16)
                                        .toRadixString(2)
                                        .padLeft(8, "0")
                                        .toString()[6] ==
                                    "1" ||
                                int.parse(list[32], radix: 16)
                                        .toRadixString(2)
                                        .padLeft(8, "0")
                                        .toString()[7] ==
                                    "1")) ||
                        int.parse(list[32], radix: 16)
                                .toRadixString(2)
                                .padLeft(8, "0")
                                .toString()[4] ==
                            "0") {
                      Get.offNamed('/Dashboard');
                    }
                    break;

                  case 1:
                    Get.offNamed('/PortalMpSalesOrder');
                    break;

                  case 2:
                    Get.offNamed('/PortalMpContract');
                    break;

                  case 3:
                    Get.offNamed('/PortalMpInvoice');
                    break;

                  case 4:
                    Get.offNamed('/TicketClientTicket');
                    break;

                  case 5:
                    Get.offNamed('/PortalMpAnomaly');
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

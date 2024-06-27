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
              initialSelected: 5,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                  visible: int.parse(list[0], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Ticket".tr,
                  visible: int.parse(list[37], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                //Richieste di offerta
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Sales Order Request".tr,
                  visible: int.parse(list[36], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                    activeIcon: Icons.person,
                    icon: EvaIcons.personOutline,
                    label: "Sales Offer".tr,
                    visible: /* int.parse(list[36], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1", */
                        false),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Purchase Order".tr,
                  visible: int.parse(list[50], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Confirm Order".tr,
                  visible: int.parse(list[49], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Training and Course".tr,
                  visible: int.parse(list[56], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                //Impianto
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Maintenance".tr,
                  visible: int.parse(list[41], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                //Impianti dettaglio
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Anomaly".tr,
                  visible: int.parse(list[40], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                //Scadenze
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Invoice".tr,
                  visible: int.parse(list[34], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Contract".tr,
                  visible: int.parse(list[38], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Sales Order B2B".tr,
                  visible: int.parse(list[51], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: Icons.person,
                  icon: EvaIcons.personOutline,
                  label: "Hours Review".tr,
                  visible: int.parse(list[44], radix: 16)
                          .toRadixString(2)
                          .padLeft(8, "0")
                          .toString()[1] ==
                      "1",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.logOut,
                  icon: EvaIcons.logOutOutline,
                  label: "Log Out",
                  visible: true,
                ),
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                //Get.toNamed('/${value.label}');
                switch (index) {
                  case 0:
                    if (int.parse(list[0], radix: 16)
                            .toRadixString(2)
                            .padLeft(8, "0")
                            .toString()[1] ==
                        "1") {
                      Get.offNamed('/Dashboard');
                    }

                    break;

                  case 1:
                    Get.offNamed('/TicketClientTicket');
                    break;
                  //Richieste di offerta
                  case 2:
                    Get.offNamed('/PortalMpOpportunity');
                    break;

                  case 3:
                    Get.offNamed('/PortalMpSalesOffer');
                    break;
                  case 4:
                    Get.offNamed('/PortalMpSalesOrder');
                    break;
                  case 5:
                    Get.offNamed('/PortalMpConfirmSalesOrder');
                    break;

                  case 6:
                    Get.offNamed('/PortalMpTrainingCourse');
                    break;
                  //Impianto
                  case 7:
                    Get.offNamed('/PortalMpMaintenanceMp');
                    break;
                  //Impianti dettaglio
                  case 8:
                    Get.offNamed('/PortalMpAnomaly');
                    break;
                  //Scadenze
                  case 9:
                    Get.offNamed('/PortalMpInvoice');
                    break;

                  case 10:
                    Get.offNamed('/PortalMpContract');
                    break;
                  case 11:
                    Get.offNamed('/PortalMpSalesOrderB2B');
                    break;
                  case 12:
                    Get.offNamed('/PortalMpHoursReview');
                    break;
                  case 13:
                    Get.offAllNamed("/");
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

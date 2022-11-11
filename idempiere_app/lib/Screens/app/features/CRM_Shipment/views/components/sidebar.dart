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
              initialSelected: 8,
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
                  visible: int.parse(list[3], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.paid,
                  icon: Icons.paid_outlined,
                  label: "Opportunity".tr,
                  visible: int.parse(list[7], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.contact_mail,
                  icon: Icons.contact_mail_outlined,
                  label: "ContactBP".tr,
                  visible: int.parse(list[4], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.domain,
                  icon: Icons.domain_outlined,
                  label: "CustomerBP".tr,
                  visible: int.parse(list[5], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.task,
                  icon: Icons.task_outlined,
                  label: "Task".tr,
                  visible: int.parse(list[6], radix: 16)
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
                  activeIcon: Icons.description,
                  icon: Icons.description_outlined,
                  label: "SalesOrder".tr,
                  visible: int.parse(list[8], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_shipping,
                  icon: Icons.local_shipping_outlined,
                  label: "Shipment".tr,
                  visible: int.parse(list[10], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.receipt,
                  icon: Icons.receipt_outlined,
                  label: "Invoice".tr,
                  visible: int.parse(list[11], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.payments,
                  icon: Icons.payments_outlined,
                  label: "Payment".tr,
                  visible: int.parse(list[12], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.request_quote,
                  icon: Icons.request_quote_outlined,
                  label: "Commission".tr,
                  visible: int.parse(list[13], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.request_quote,
                  icon: Icons.request_quote_outlined,
                  label: "Open Items".tr,
                  visible: int.parse(list[14], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.request_quote,
                  icon: Icons.request_quote_outlined,
                  label: "Price List".tr,
                  visible: int.parse(list[15], radix: 16)
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
                    Get.offNamed('/ProductList');
                    break;
                  case 7:
                    Get.offNamed('/SalesOrder');
                    break;
                  case 8:
                    Get.offNamed('/Shipment');
                    break;
                  case 9:
                    Get.offNamed('/Invoice');
                    break;
                  case 10:
                    Get.offNamed('/Payment');
                    break;
                  case 11:
                    Get.offNamed('/Commission');
                    break;
                  case 12:
                    Get.offNamed('/OpenItems');
                    break;
                  case 13:
                    Get.offNamed('/PriceList');
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

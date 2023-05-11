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
              initialSelected: 2,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Purchase Lead".tr,
                  visible: int.parse(list[59], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "PurchaseProductwarehouseprice".tr,
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
              ],
              onSelected: (index, value) {
                //log("index : $index | label : ${value.label}");
                //Get.toNamed('/${value.label}');
                switch (index) {
                  case 0:
                    Get.offNamed('/Dashboard');
                    break;

                  case 1:
                    Get.offNamed('/PurchaseLead');
                    break;

                  case 2:
                    Get.offNamed('/PurchaseProductwarehouseprice');
                    break;
                  case 3:
                    Get.offNamed('/PurchaseProductList');
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

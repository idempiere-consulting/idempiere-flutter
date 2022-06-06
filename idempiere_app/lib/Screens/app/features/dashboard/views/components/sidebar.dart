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
                  visible: int.parse(list[0], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  label: "Email".tr,
                  totalNotif: 20,
                  visible: int.parse(list[1], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.attractions,
                  icon: Icons.attractions_outlined,
                  label: "CRM".tr,
                  visible: int.parse(list[2], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.sell,
                  icon: Icons.sell_outlined,
                  label: "Ticket".tr,
                  visible: int.parse(list[16], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.build,
                  icon: Icons.build_outlined,
                  label: "Maintenance".tr,
                  visible: int.parse(list[22], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.dashboard,
                  icon: Icons.dashboard_outlined,
                  label: "PortalMp".tr,
                  visible: int.parse(list[32], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true && GetStorage().read("isOffline") == false
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.shopping_cart,
                  icon: Icons.shopping_cart_outlined,
                  label: "Purchase".tr,
                  visible: int.parse(list[58], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.local_convenience_store,
                  icon: Icons.local_convenience_store_outlined,
                  label: "Supplychain".tr,
                  visible: int.parse(list[63], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.emoji_transportation,
                  icon: Icons.emoji_transportation_outlined,
                  label: "VehicleEquipment".tr,
                  visible: int.parse(list[68], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.emoji_transportation,
                  icon: Icons.emoji_transportation_outlined,
                  label: "Production".tr,
                  visible: int.parse(list[75], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.real_estate_agent,
                  icon: Icons.real_estate_agent_outlined,
                  label: "DashboardAssetresource".tr,
                  visible: int.parse(list[2], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? false
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.personOutline,
                  label: "HumanResource".tr,
                  visible: int.parse(list[92], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.personOutline,
                  label: "Employee".tr,
                  visible: int.parse(list[103], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.bookOpenOutline,
                  label: "Training and Course".tr,
                  visible: int.parse(list[52], radix: 16)
                                  .toRadixString(2)
                                  .padLeft(4, "0")
                                  .toString()[1] ==
                              "1" &&
                          GetStorage().read("isOffline") == false
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.personAdd,
                  icon: EvaIcons.personOutline,
                  label: "Profil".tr,
                  visible:
                      GetStorage().read("isOffline") == false ? false : false,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Setting".tr,
                  visible:
                      GetStorage().read("isOffline") == false ? true : false,
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
                    Get.offNamed('/TicketInternal');
                    break;
                  case 5:
                    Get.offNamed('/Maintenance');
                    break;
                  case 6:
                    Get.offNamed('/TicketClient');
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
                    Get.offNamed('/Production');
                    break;
                  case 11:
                    Get.offNamed('/DashboardAssetresource');
                    break;
                  case 12:
                    Get.offNamed('/HumanResource');
                    break;
                  case 13:
                    Get.offNamed('/Employee');
                    break;
                  case 14:
                    Get.offNamed('/TrainingCourse');
                    break;
                  case 15:
                    Get.offNamed('/Profil');
                    break;
                  case 16:
                    Get.offNamed('/Settings');
                    break;
                  case 17:
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

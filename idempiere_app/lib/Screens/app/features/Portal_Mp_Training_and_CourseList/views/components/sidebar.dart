part of dashboard;

// ignore: must_be_immutable
class _Sidebar extends StatelessWidget {
  _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

  final List<dynamic> list = GetStorage().read('permission');

  TextEditingController passwordFieldController = TextEditingController();

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
                ),
                SelectionButtonData(
                  activeIcon: Icons.person_add,
                  icon: EvaIcons.personOutline,
                  label: "Training and Course",
                  visible: int.parse(list[52], radix: 16)
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
                  label: "Course Attendance",
                  visible: int.parse(list[53], radix: 16)
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
                  label: "Quiz",
                  visible: int.parse(list[54], radix: 16)
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
                  label: "Score",
                  visible: int.parse(list[55], radix: 16)
                              .toRadixString(2)
                              .padLeft(4, "0")
                              .toString()[1] ==
                          "1"
                      ? true
                      : false,
                ),
                SelectionButtonData(
                  activeIcon: Icons.person_add,
                  icon: EvaIcons.personOutline,
                  label: "Course List",
                  visible: int.parse(list[57], radix: 16)
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
                    Get.offNamed('/PortalMpTrainingCourse');
                    break;
                  case 2:
                    Get.offNamed('/PortalMpTrainingCoursePresence');
                    break;
                  case 3:
                    Get.offNamed('/PortalMpTrainingCourseSurvey');
                    break;
                  case 4:
                    Get.offNamed('/PortalMpTrainingCourseScore');
                    break;
                  case 5:
                    Get.offNamed('/PortalMpTrainingCourseCourseListScreen');
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

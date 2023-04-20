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
              initialSelected: 1,
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.arrowBack,
                  icon: EvaIcons.arrowBackOutline,
                  label: "Dashboard".tr,
                ),
                SelectionButtonData(
                  activeIcon: Icons.paid,
                  icon: Icons.paid_outlined,
                  label: "Course Attendance".tr,
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
                  label: "Quiz".tr,
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
                  label: "Score".tr,
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
                  label: "Course List".tr,
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
                    Get.offNamed('/TrainingCoursePresence');
                    break;
                  case 2:
                    /* Get.defaultDialog(
                      title: "Your Quiz Code:",
                      content: RoundedPasswordField(
                        controller: passwordFieldController,
                        onChanged: (value) {},
                      ),
                      barrierDismissible: true,
                      textConfirm: 'Confirm',
                      buttonColor: kNotifColor,
                      onConfirm: () async {
                        final ip = GetStorage().read('ip');
                        String authorization =
                            'Bearer ' + GetStorage().read('token');
                        final protocol = GetStorage().read('protocol');
                        var url = Uri.parse('$protocol://' +
                            ip +
                            '/api/v1/models/MP_Maintain_Resource?\$filter= MP_Maintain_Resource_UU eq \'${passwordFieldController.text}\' and AD_Client_ID eq ${GetStorage().read('clientid')}');

                        var response = await http.get(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization': authorization,
                          },
                        );
                        if (response.statusCode == 200) {
                          print(response.body);
                          var json = pagejsonDecode(response.body);
                          if (json['row-count'] == 1) {
                            Get.offNamed('/TrainingCourseSurvey', arguments: {
                              "id": json["records"][0]["id"],
                            });
                          }
                        } else {
                          print(response.body);
                        }
                      },
                    ); */
                    Get.offNamed('/TrainingCourseSurvey');
                    break;
                  case 3:
                    Get.offNamed('/TrainingCourseScore');
                    break;
                  case 4:
                    Get.offNamed('/TrainingCourseCourseListScreen');
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

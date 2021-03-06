import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/app/constans/app_constants.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_create_tasks.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProress;

  const ProgressCardData({
    required this.totalUndone,
    required this.totalTaskInProress,
  });
}

// ignore: must_be_immutable
class ProgressCard extends StatelessWidget {
  ProgressCard({
    required this.data,
    required this.onPressedCheck,
    this.text = "zz",
    Key? key,
  }) : super(key: key);

  String text;
  ProgressCardData data;
  VoidCallback onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    ImageVectorPath.happy2,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kSpacing,
              top: kSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You Have".tr + " ${data.totalUndone} " + "Undone Tasks".tr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "${data.totalTaskInProress} " + "Tasks are in progress".tr,
                  style: TextStyle(color: kFontColorPallets[1]),
                ),
                const SizedBox(height: kSpacing),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const CreateDashboardTasks());
                  },
                  child: Text('Create Entry'.tr),
                ),
                const SizedBox(
                  height: kSpacing,
                ),
                ElevatedButton(
                  onPressed: () {
                    /* if (Get.find<DashboardController>().filterCount == 0) {
                      Get.find<DashboardController>().changeFilter();
                      GetStorage().write(
                          'signEntryDateTime', DateTime.now().toString());
                    } else {
                      Get.find<DashboardController>().changeFilter();
                      GetStorage()
                          .write('signExitDateTime', DateTime.now().toString());
                    } */
                    GetStorage()
                        .write('signEntryDateTime', DateTime.now().toString());
                    Get.toNamed('DashboardTasks');
                  },
                  child: Text('Sign Entry'.tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

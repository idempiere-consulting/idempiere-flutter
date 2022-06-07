    import 'package:flutter/material.dart';
    import 'package:get/get.dart';
    import 'package:idempiere_app/Screens/IdempiereUrlSet/components/body.dart';
    import 'package:idempiere_app/Screens/Welcome/welcome_screen.dart';

    class IdempiereUrl extends StatelessWidget {
      const IdempiereUrl({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Get.off(const WelcomeScreen());
            return false;
          },
          child: const Scaffold(
            body: Body(),
          ),
        );
      }
    }

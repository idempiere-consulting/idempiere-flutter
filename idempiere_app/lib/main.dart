import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:idempiere_app/Screens/IdempiereUrlSet/idempiere_set_url.dart';
//import 'package:idempiere_app/Screens/Login/login_screen.dart';
//import 'package:idempiere_app/Screens/LoginOrganizations/loginorganizations_screen.dart';
//import 'package:idempiere_app/Screens/LoginRoles/loginroles_screen.dart';
//import 'package:idempiere_app/Screens/LoginWarehouses/loginwarehouses.dart';
import 'package:idempiere_app/Screens/app/config/themes/app_theme.dart';
import 'package:idempiere_app/Screens/app/features/CRM/views/screens/crm_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contatti_BP/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
//import 'package:idempiere_app/constants.dart';
import 'package:idempiere_app/Screens/Welcome/welcome_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'iDempiereApp',
      theme: AppTheme.basic,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(
          name: '/Dashboard',
          page: () => const DashboardScreen(),
          binding: DashboardBinding(),
        ),
        GetPage(
          name: '/CRM',
          page: () => const CRMScreen(),
          binding: CRMBinding(),
        ),
        GetPage(
          name: '/Lead',
          page: () => const CRMLeadScreen(),
          binding: CRMLeadBinding(),
        ),
        GetPage(
          name: '/Opportunity',
          page: () => const CRMOpportunityScreen(),
          binding: CRMOpportunityBinding(),
        ),
        GetPage(
          name: '/Contatti',
          page: () => const CRMContattiBPScreen(),
          binding: CRMContattiBPBinding(),
        ),
      ],
      /* routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const WelcomeScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/seturl': (context) => const IdempiereUrl(),
          '/loginscreen': (context) => const LoginScreen(),
          '/loginroles': (context) => const LoginRoles(),
          '/loginorganization': (context) => const LoginOrganizations(),
          '/loginwarehouse': (context) => const LoginWarehouses(),
        }*/
    );
  }
}

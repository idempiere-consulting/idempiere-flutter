import 'dart:io';

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
import 'package:idempiere_app/Screens/app/features/CRM_Commission/views/screens/crm_commission_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/views/screens/crm_contact_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/views/screens/crm_customer_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/views/screens/crm_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Payment/views/screens/crm_payment_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/views/screens/crm_shipmentline_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_task_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Course_Quiz/views/screens/course_quiz_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee/views/screens/employee_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource/views/screens/human_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource_Ticket/views/screens/humanresource_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance/views/screens/maintenance_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Calendar/views/screens/maintenance_calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Internaluseinventory/views/screens/maintenance_internaluseinventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpimportitem/views/screens/maintenance_mpimportitem_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpnomaly/views/screens/maintenance_mpanomaly_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mppicking/views/screens/maintenance_mppicking_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_A2_Fire_Extinguisher_Grid/views/screens/maintenance_mptask_resource_fire_extinguisher_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_Sheet/views/screens/maintenance_mptask_resource_sheet_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpwarehouse/views/screens/maintenance_mpwarehouse_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maps/maps_page.dart';
import 'package:idempiere_app/Screens/app/features/Notification/views/screens/notification_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp/views/screens/portal_mp_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Invoicepo/views/screens/portal_mp_invoicepo_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Portaloffer/views/screens/portal_mp_portaloffer_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase/views/screens/purchase_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Lead/views/screens/purchase_lead_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Productwarehouseprice/views/screens/purchase_productwarehouseprice_screen.dart';
import 'package:idempiere_app/Screens/app/features/Settings/views/screens/settings_screen.dart';
import 'package:idempiere_app/Screens/app/features/Signature/signature_page.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain/views/screens/supplychain_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory/views/screens/supplychain_inventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Productwarehouse/views/screens/supplychain_productwarehouse_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket/views/screens/ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client/views/screens/ticketclient_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Client_Ticket/views/screens/ticketclient_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Internal/views/screens/ticketinternal_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Internal_Ticket/views/screens/ticketinternal_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Resource_Assignment/views/screens/ticket_resource_assignment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Task_ToDo/views/screens/ticket_task_todo_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Ticket_New/views/screens/ticket_ticket_new_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course/views/screens/training_course_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_Presence/views/screens/training_course_presence_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_Score/views/screens/training_course_score_screen.dart';
import 'package:idempiere_app/Screens/app/features/Training_and_Course_Survey/views/screens/training_course_survey_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment/views/screens/vehicle_equipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Equipment/views/screens/vehicle_equipment_equipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/views/screens/vehicle_equipment_vehicle_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_tasks/views/screens/dashboard_tasks_screen.dart';
import 'package:idempiere_app/components/ignoressl.dart';
import 'package:idempiere_app/Screens/Welcome/welcome_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_assetresource/views/screens/dashboard_assetresource_screen.dart';
import 'package:idempiere_app/localestrings.dart';

//import 'components/ignoressl.dart';

void main() async {
  HttpOverrides.global = DevHttpOverrides();

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocaleString(),
      locale: const Locale('it', 'IT'),
      title: 'iDempiereApp',
      theme: AppTheme.basic,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const WelcomeScreen(),
        ),
        GetPage(
          name: '/Dashboard',
          page: () => const DashboardScreen(),
          binding: DashboardBinding(),
        ),
        GetPage(
          name: '/DashboardTasks',
          page: () => const DashboardTasksScreen(),
          binding: DashboardTasksBinding(),
        ),
        GetPage(
          name: '/Notification',
          page: () => const NotificationScreen(),
          binding: NotificationBinding(),
        ),
        GetPage(
          name: '/CRM',
          page: () => const CRMScreen(),
          binding: CRMBinding(),
        ),
        GetPage(
          name: '/Calendar',
          page: () => const CalendarScreen(),
          //binding: CalendarBinding(),
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
          name: '/ContactBP',
          page: () => const CRMContactBPScreen(),
          binding: CRMContactBPBinding(),
        ),
        GetPage(
          name: '/CustomerBP',
          page: () => const CRMCustomerBPScreen(),
          binding: CRMCustomerBPBinding(),
        ),
        GetPage(
          name: '/Task',
          page: () => const CRMTaskScreen(),
          binding: CRMTaskBinding(),
        ),
        GetPage(
          name: '/SalesOrder',
          page: () => const CRMSalesOrderScreen(),
          binding: CRMSalesOrderBinding(),
        ),
        GetPage(
          name: '/ProductList',
          page: () => const CRMProductListScreen(),
          binding: CRMProductListBinding(),
        ),
        GetPage(
          name: '/Invoice',
          page: () => const CRMInvoiceScreen(),
          binding: CRMInvoiceBinding(),
        ),
        GetPage(
          name: '/Payment',
          page: () => const CRMPaymentScreen(),
          binding: CRMPaymentBinding(),
        ),
        GetPage(
          name: '/Commission',
          page: () => const CRMCommissionScreen(),
          binding: CRMCommissionBinding(),
        ),
        GetPage(
          name: '/Shipment',
          page: () => const CRMShipmentScreen(),
          binding: CRMShipmentBinding(),
        ),
        GetPage(
          name: '/ShipmentLine',
          page: () => const CRMShipmentlineScreen(),
          binding: CRMShipmentlineBinding(),
        ),
        GetPage(
          name: '/TicketClient',
          page: () => const TicketClientScreen(),
          binding: TicketClientBinding(),
        ),
        GetPage(
          name: '/TicketClientTicket',
          page: () => const TicketClientTicketScreen(),
          binding: TicketClientTicketBinding(),
        ),
        GetPage(
          name: '/TicketInternal',
          page: () => const TicketInternalScreen(),
          binding: TicketInternalBinding(),
        ),
        GetPage(
          name: '/TicketInternalTicket',
          page: () => const TicketInternalTicketScreen(),
          binding: TicketInternalTicketBinding(),
        ),
        GetPage(
          name: '/Ticket',
          page: () => const TicketScreen(),
          binding: TicketBinding(),
        ),
        GetPage(
          name: '/TicketTicketNew',
          page: () => const TicketTicketNewScreen(),
          binding: TicketTicketNewBinding(),
        ),
        GetPage(
          name: '/TicketTaskToDo',
          page: () => const TicketTaskToDoScreen(),
          binding: TicketTaskToDoBinding(),
        ),
        GetPage(
          name: '/TicketResourceAssignment',
          page: () => const TicketResourceAssignmentScreen(),
          binding: TicketResourceAssignmentBinding(),
        ),
        GetPage(
          name: '/TrainingCourse',
          page: () => const TrainingCourseScreen(),
          binding: TrainingCourseBinding(),
        ),
        GetPage(
          name: '/TrainingCoursePresence',
          page: () => const TrainingCoursePresenceScreen(),
          binding: TrainingCoursePresenceBinding(),
        ),
        GetPage(
          name: '/TrainingCourseScore',
          page: () => const TrainingCourseScoreScreen(),
          binding: TrainingCourseScoreBinding(),
        ),
        GetPage(
          name: '/TrainingCourseSurvey',
          page: () => const TrainingCourseSurveyScreen(),
          binding: TrainingCourseSurveyBinding(),
        ),
        GetPage(
          name: '/QuizCourse',
          page: () => const CourseQuizScreen(),
          binding: CourseQuizBinding(),
        ),
        GetPage(
          name: '/Maintenance',
          page: () => const MaintenanceScreen(),
          binding: MaintenanceBinding(),
        ),
        GetPage(
          name: '/MaintenanceCalendar',
          page: () => const MaintenanceCalendarScreen(),
          binding: MaintenanceCalendarBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptask',
          page: () => const MaintenanceMptaskScreen(),
          binding: MaintenanceMptaskBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptaskLine',
          page: () => const MaintenanceMptaskLineScreen(),
          binding: MaintenanceMptaskLineBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpResource',
          page: () => const MaintenanceMpResourceScreen(),
          binding: MaintenanceMpResourceBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpResourceFireExtinguisherGrid',
          page: () => const MaintenanceMpResourceFireExtinguisherScreen(),
          binding: MaintenanceMpResourceFireExtinguisherBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpResourceSheet',
          page: () => const MaintenanceMpResourceSheetScreen(),
          binding: MaintenanceMpResourceSheetBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpanomaly',
          page: () => const MaintenanceMpanomalyScreen(),
          binding: MaintenanceMpanomalyBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpwarehouse',
          page: () => const MaintenanceMpwarehouseScreen(),
          binding: MaintenanceMpwarehouseBinding(),
        ),
        GetPage(
          name: '/MaintenanceMppicking',
          page: () => const MaintenanceMppickingScreen(),
          binding: MaintenanceMppickingBinding(),
        ),
        GetPage(
          name: '/MaintenanceInternaluseinventory',
          page: () => const MaintenanceInternaluseinventoryScreen(),
          binding: MaintenanceInternaluseinventoryBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpimportitem',
          page: () => const MaintenanceMpimportitemScreen(),
          binding: MaintenanceMpimportitemBinding(),
        ),
        GetPage(
          name: '/MapsScreen',
          page: () => const MobileMapsScreen(),
        ),
        GetPage(
          name: '/PortalMp',
          page: () => const PortalMpScreen(),
          binding: PortalMpBinding(),
        ),
        GetPage(
          name: '/PortalMpInvoicepo',
          page: () => const PortalMpInvoicepoScreen(),
          binding: PortalMpInvoicepoBinding(),
        ),
        GetPage(
          name: '/PortalMpPortaloffer',
          page: () => const PortalMpPortalofferScreen(),
          binding: PortalMpPortalofferBinding(),
        ),
        GetPage(
          name: '/Purchase',
          page: () => const PurchaseScreen(),
          binding: PurchaseBinding(),
        ),
        GetPage(
          name: '/PurchaseLead',
          page: () => const PurchaseLeadScreen(),
          binding: PurchaseLeadBinding(),
        ),
        GetPage(
          name: '/PurchaseProductwarehouseprice',
          page: () => const PurchaseProductwarehousepriceScreen(),
          binding: PurchaseProductwarehousepriceBinding(),
        ),
        GetPage(
          name: '/Supplychain',
          page: () => const SupplychainScreen(),
          binding: SupplychainBinding(),
        ),
        GetPage(
          name: '/Signature',
          page: () => const SignatureScreen(),
        ),
        GetPage(
          name: '/SupplychainProductwarehouse',
          page: () => const SupplychainProductwarehouseScreen(),
          binding: SupplychainProductwarehouseBinding(),
        ),
        GetPage(
          name: '/SupplychainInventory',
          page: () => const SupplychainInventoryScreen(),
          binding: SupplychainInventoryBinding(),
        ),
        GetPage(
          name: '/SupplychainMaterialreceipt',
          page: () => const SupplychainMaterialreceiptScreen(),
          binding: SupplychainMaterialreceiptBinding(),
        ),
        GetPage(
          name: '/VehicleEquipment',
          page: () => const VehicleEquipmentScreen(),
          binding: VehicleEquipmentBinding(),
        ),
        GetPage(
          name: '/VehicleEquipmentVehicle',
          page: () => const VehicleEquipmentVehicleScreen(),
          binding: VehicleEquipmentVehicleBinding(),
        ),
        GetPage(
          name: '/VehicleEquipmentEquipment',
          page: () => const VehicleEquipmentEquipmentScreen(),
          binding: VehicleEquipmentEquipmentBinding(),
        ),
        GetPage(
          name: '/DashboardAssetresource',
          page: () => const DashboardAssetresourceScreen(),
          binding: DashboardAssetresourceBinding(),
        ),
        GetPage(
          name: '/HumanResource',
          page: () => const HumanResourceScreen(),
          binding: HumanResourceBinding(),
        ),
        GetPage(
          name: '/HumanResourceTicket',
          page: () => const HumanResourceTicketScreen(),
          binding: HumanResourceTicketBinding(),
        ),
        GetPage(
          name: '/Employee',
          page: () => const EmployeeScreen(),
          binding: EmployeeBinding(),
        ),
        GetPage(
          name: '/Settings',
          page: () => const SettingsScreen(),
          binding: SettingsBinding(),
        ),
      ],
    );
  }
}

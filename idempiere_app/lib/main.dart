import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_app/Screens/Login/login_screen.dart';
import 'package:idempiere_app/Screens/app/config/themes/app_theme.dart';
import 'package:idempiere_app/Screens/app/features/Accounting/views/screens/accounting_screen.dart';
import 'package:idempiere_app/Screens/app/features/Accounting_Asset/views/screens/accounting_asset_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM/views/screens/crm_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Commission/views/screens/crm_commission_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contact_BP/views/screens/crm_contact_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_POS/views/screens/crm_pos_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_BP_PriceList/views/screens/crm_sales_order_creation_bp_pricelist_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_BP_PriceList_Edit/views/screens/crm_sales_order_creation_bp_priceList_edit_screen.dart';
import 'package:idempiere_app/Screens/app/features/Desk_Doc_Attachments/views/screens/desk_doc_attachments_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource/views/screens/employee_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Resource_Calendar_Slot/views/screens/employee_resource_calendar_slot_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource_Attendance/views/screens/humanresource_attendance_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource_Employee_Sheet/views/screens/humanresource_employee_sheet_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard/views/screens/maintenance_mptask_standard_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Standard_taskline/views/screens/maintenance_mptask_standard_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Permission_Customization/views/screens/permission_customization_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Confirm_Sales_Order/views/screens/portal_mp_confirm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Hours_Review/views/screens/portal_mp_hoursreview_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order/views/screens/portal_mp_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_Creation_BP_PriceList_Edit/views/screens/portal_mp_sales_order_creation_BP_PriceList_edit_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_order_From_Pricelist/views/screens/portal_mp_sales_orderfrom_pricelist_screen.dart';
import 'package:idempiere_app/Screens/app/features/Production_Advancement_State/views/screens/production_advancement_state_screen.dart';
import 'package:idempiere_app/Screens/app/features/Project_Dashboard/views/screens/project_dashboard_screen.dart';
import 'package:idempiere_app/Screens/app/features/Project_List/views/screens/project_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Contract_Line/views/screens/crm_contract_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Contract_Line/views/screens/crm_contract_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Customer_BP/views/screens/crm_customer_bp_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice/views/screens/crm_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Invoice_Line/views/screens/crm_invoice_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Invoice_Line/views/screens/crm_invoice_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Leads/views/screens/crm_leads_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Open_Items/views/screens/crm_openitems_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Opportunity/views/screens/crm_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Payment/views/screens/crm_payment_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Price_List/views/screens/crm_price_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Product_List/views/screens/crm_product_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Contract/views/screens/crm_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Invoice/views/screens/crm_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Order_Line/views/screens/crm_sales_order_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation/views/screens/crm_sales_order_creation_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Creation_Contract/views/screens/crm_sales_order_contract_creation_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order_Line/views/screens/crm_sales_order_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment_line/views/screens/crm_shipmentline_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task/views/screens/crm_task_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Charts/interval.dart';
import 'package:idempiere_app/Screens/app/features/Charts/liea_area_point.dart';
import 'package:idempiere_app/Screens/app/features/Course_Quiz/views/screens/course_quiz_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee/views/screens/employee_screen.dart';
import 'package:idempiere_app/Screens/app/features/Employee_Ticket/views/screens/employee_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource/views/screens/human_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource_Ticket/views/screens/humanresource_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Human_Resource_Work_Hours/views/screens/human_resource_work_hours_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance/views/screens/maintenance_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Calendar/views/screens/maintenance_calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Internaluseinventory/views/screens/maintenance_internaluseinventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts/views/screens/crm_maintenance_mpcontacts_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_MpContracts_Create_Contract/views/screens/crm_maintenance_mpcontacts_create_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpimportitem/views/screens/maintenance_mpimportitem_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpnomaly/views/screens/maintenance_mpanomaly_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mppicking/views/screens/maintenance_mppicking_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_List/views/screens/mptask_anomaly_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_Anomaly_Review/views/screens/mptask_anomaly_review_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource/views/screens/maintenance_mptask_resource_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_Sheet/views/screens/maintenance_mptask_resource_sheet_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_resource_barcode/views/screens/maintenance_mptask_resource_barcode_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask_taskline/views/screens/maintenance_mptask_taskline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpwarehouse/views/screens/maintenance_mpwarehouse_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Shipment/views/screens/maintenance_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Shipment_line/views/screens/maintenance_shipmentline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Notification/views/screens/notification_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp/views/screens/portal_mp_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Anomaly/views/screens/portal_mp_anomaly_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Contract/views/screens/portal_mp_contract_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Invoice/views/screens/portal_mp_invoice_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Maintenance/views/screens/portal_mp_maintenance_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Opportunity/views/screens/portal_mp_opportunity_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Sales_Order_B2B/views/screens/portal_mp_sales_order_b2b_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Training_and_CourseList/views/screens/portal_mp_training_course_courselist_screen.dart';
import 'package:idempiere_app/Screens/app/features/Production/views/screens/production_screen.dart';
import 'package:idempiere_app/Screens/app/features/Production_Order/views/screens/production_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase/views/screens/purchase_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Lead/views/screens/purchase_lead_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Payment/views/screens/crm_payment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Price_List/views/screens/purchase_price_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Product_List/views/screens/crm_product_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Productwarehouseprice/views/screens/purchase_productwarehouseprice_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Request/views/screens/purchase_request_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Request_Creation/views/screens/purchase_request_creation_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Request_Creation_Edit/views/screens/purchase_request_creation_edit_screen.dart';
import 'package:idempiere_app/Screens/app/features/Settings/views/screens/settings_screen.dart';
import 'package:idempiere_app/Screens/app/features/Signature/signature_page.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain/views/screens/supplychain_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory/views/screens/supplychain_inventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory_Line/views/screens/supplychain_inventoryline_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory_Lot/views/screens/supplychain_inventory_lot_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory_Lot_Line/views/screens/supplychain_inventory_lot_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload/views/screens/supplychain_load_unload_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Load_Unload_Line/views/screens/supplychain_load_unload_line_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Maintenance_LockUnlock_Container/views/screens/supplychain_maintenance_lockunlock_container_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Maintenance_Switch_Resource/views/screens/supplychain_maintenance_switch_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt_Creation/views/screens/supplychain_materialreceipt_creation_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Product_List/views/screens/supplychain_product_list_screen.dart';
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
import 'package:idempiere_app/Screens/app/features/Training_and_Course_CourseList/views/screens/training_course_courselist_screen.dart';
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

import 'Screens/app/features/Portal_Mp_Sales_Offer/views/screens/portal_mp_sales_order_screen.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('en', 'US'), Locale('it', 'IT')],
      translations: LocaleString(),
      locale: Locale(GetStorage().read('language') ?? 'it_IT'),
      theme: AppTheme.basic,
      initialRoute: GetStorage().read("ip") == null ? '/' : '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const WelcomeScreen(),
        ),
        GetPage(
          name: '/Login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/LinearCharts',
          page: () => LineAreaPointPage(),
        ),
        GetPage(
          name: '/IntervalCharts',
          page: () => IntervalPage(),
        ),
        GetPage(
          name: '/PermissionCustomization',
          page: () => const PermissionCustomizationScreen(),
          binding: PermissionCustomizationBinding(),
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
          name: '/Accounting',
          page: () => const AccountingScreen(),
          binding: AccountingBinding(),
        ),
        GetPage(
          name: '/AccountingAsset',
          page: () => const AccountingAssetScreen(),
          binding: AccountingAssetBinding(),
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
          name: '/Contract',
          page: () => const CRMContractScreen(),
          binding: CRMContractBinding(),
        ),

        GetPage(
          name: '/ContractLine',
          page: () => const CRMContractLineScreen(),
          binding: CRMContractLineBinding(),
        ),
        GetPage(
          name: '/ContractCustomerLine',
          page: () => const CRMContractCustomerLineScreen(),
          binding: CRMContractCustomerLineBinding(),
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
          name: '/SalesOrderCreation',
          page: () => const CRMSalesOrderCreationScreen(),
          binding: CRMSalesOrderCreationBinding(),
        ),
        GetPage(
          name: '/SalesOrderCreationBPPricelist',
          page: () => const CRMSalesOrderCreationBPPricelistScreen(),
          binding: CRMSalesOrderCreationBPPricelistBinding(),
        ),
        GetPage(
          name: '/SalesOrderCreationBPPricelistEdit',
          page: () => const CRMSalesOrderCreationBPPriceListEditScreen(),
          binding: CRMSalesOrderCreationBPPriceListEditBinding(),
        ),
        GetPage(
          name: '/SalesOrderContractCreation',
          page: () => const CRMSalesOrderContractCreationScreen(),
          binding: CRMSalesOrderContractCreationBinding(),
        ),
        GetPage(
          name: '/SalesOrderLine',
          page: () => const CRMSalesOrderLineScreen(),
          binding: CRMSalesOrderLineBinding(),
        ),
        GetPage(
          name: '/PurchaseOrderLine',
          page: () => const CRMPurchaseOrderLineScreen(),
          binding: CRMPurchaseOrderLineBinding(),
        ),
        GetPage(
          name: '/ProductList',
          page: () => const CRMProductListScreen(),
          binding: CRMProductListBinding(),
        ),
        GetPage(
          name: '/PriceList',
          page: () => const CRMPriceListScreen(),
          binding: CRMPriceListBinding(),
        ),
        GetPage(
          name: '/Invoice',
          page: () => const CRMInvoiceScreen(),
          binding: CRMInvoiceBinding(),
        ),
        GetPage(
          name: '/InvoiceLine',
          page: () => const CRMInvoiceLineScreen(),
          binding: CRMInvoiceLineBinding(),
        ),
        GetPage(
          name: '/InvoicePOLine',
          page: () => const CRMInvoicePOLineScreen(),
          binding: CRMInvoicePOLineBinding(),
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
          name: '/POS',
          page: () => const CRMPOSScreen(),
          binding: CRMPOSBinding(),
        ),
        GetPage(
          name: '/Production',
          page: () => const ProductionScreen(),
          binding: ProductionBinding(),
        ),
        GetPage(
          name: '/ProductionOrder',
          page: () => const ProductionOrderScreen(),
          binding: ProductionOrderBinding(),
        ),
        GetPage(
          name: '/ProductionAdvancementState',
          page: () => const ProductionAdvancementStateScreen(),
          binding: ProductionAdvancementStateBinding(),
        ),
        GetPage(
          name: '/ProjectDashboard',
          page: () => const ProjectDashboardScreen(),
          binding: ProjectDashboardBinding(),
        ),
        GetPage(
          name: '/ProjectList',
          page: () => const ProjectListScreen(),
          binding: ProjectListBinding(),
        ),
        GetPage(
          name: '/OpenItems',
          page: () => const CRMOpenItemsScreen(),
          binding: CRMOpenItemsBinding(),
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
          name: '/DeskDocAttachments',
          page: () => const DeskDocAttachmentsScreen(),
          binding: DeskDocAttachmentsBinding(),
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
        //TrainingCourseCourseListScreen
        GetPage(
          name: '/TrainingCourseCourseListScreen',
          page: () => const TrainingCourseCourseListScreen(),
          binding: TrainingCourseCourseListBinding(),
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
          name: '/MaintenanceShipment',
          page: () => const MaintenanceShipmentScreen(),
          binding: MaintenanceShipmentBinding(),
        ),
        GetPage(
          name: '/MaintenanceShipmentLine',
          page: () => const MaintenanceShipmentlineScreen(),
          binding: MaintenanceShipmentlineBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptask',
          page: () => const MaintenanceMptaskScreen(),
          binding: MaintenanceMptaskBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptaskStandard',
          page: () => const MaintenanceMptaskStandardScreen(),
          binding: MaintenanceMptaskStandardBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpContracts',
          page: () => const MaintenanceMpContractsScreen(),
          binding: MaintenanceMpContractsBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpContractsCreateContract',
          page: () => const MaintenanceMpContractsCreateContractScreen(),
          binding: MaintenanceMpContractsCreateContractBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptaskAnomalyReview',
          page: () => const AnomalyReviewScreen(),
          binding: AnomalyReviewBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptaskAnomalyList',
          page: () => const AnomalyListScreen(),
          binding: AnomalyListBinding(),
        ),
        GetPage(
          name: '/MaintenanceMptaskLine',
          page: () => const MaintenanceMptaskLineScreen(),
          binding: MaintenanceMptaskLineBinding(),
        ),
        GetPage(
          name: '/MaintenanceStandardMptaskLine',
          page: () => const MaintenanceStandardMptaskLineScreen(),
          binding: MaintenanceStandardMptaskLineBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpResource',
          page: () => const MaintenanceMpResourceScreen(),
          binding: MaintenanceMpResourceBinding(),
        ),
        GetPage(
          name: '/MaintenanceMpResourceBarcode',
          page: () => const MaintenanceMpResourceBarcodeScreen(),
          binding: MaintenanceMpResourceBarcodeBinding(),
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
        /* GetPage(
          name: '/MapsScreen',
          page: () => const MobileMapsScreen(),
        ), */
        GetPage(
          name: '/PortalMp',
          page: () => const PortalMpScreen(),
          binding: PortalMpBinding(),
        ),
        GetPage(
          name: '/PortalMpInvoice',
          page: () => const PortalMpInvoiceScreen(),
          binding: PortalMpInvoiceBinding(),
        ),
        GetPage(
          name: '/PortalMpContract',
          page: () => const PortalMpContractScreen(),
          binding: PortalMpContractBinding(),
        ),
        GetPage(
          name: '/PortalMpAnomaly',
          page: () => const PortalMpAnomalyScreen(),
          binding: PortalMpAnomalyBinding(),
        ),
        GetPage(
          name: '/PortalMpMaintenanceMp',
          page: () => const PortalMpMaintenanceMpScreen(),
          binding: PortalMpMaintenanceMpBinding(),
        ),
        GetPage(
          name: '/PortalMpSalesOrder',
          page: () => const PortalMpSalesOrderScreen(),
          binding: PortalMpSalesOrderBinding(),
        ),
        GetPage(
          name: '/PortalMpConfirmSalesOrder',
          page: () => const PortalMpConfirmSalesOrderScreen(),
          binding: PortalMpConfirmSalesOrderBinding(),
        ),
        GetPage(
          name: '/PortalMpCreateSalesOrderFromPriceList',
          page: () => const PortalMpSalesOrderFromPriceListScreen(),
          binding: PortalMpSalesOrderFromPriceListBinding(),
        ),
        GetPage(
          name: '/PortalMpCreationBPPricelistEdit',
          page: () => const PortalMpSalesOrderCreationBPPriceListEditScreen(),
          binding: PortalMpSalesOrderCreationBPPriceListEditBinding(),
        ),
        GetPage(
          name: '/PortalMpSalesOffer',
          page: () => const PortalMpSalesOfferScreen(),
          binding: PortalMpSalesOfferBinding(),
        ),
        GetPage(
          name: '/PortalMpHoursReview',
          page: () => const PortalMpHoursReviewScreen(),
          binding: PortalMpHoursReviewBinding(),
        ),
        GetPage(
          name: '/PortalMpSalesOrderB2B',
          page: () => const PortalMpSalesOrderB2BScreen(),
          binding: PortalMpSalesOrderB2BBinding(),
        ),
        GetPage(
          name: '/PortalMpTrainingCourse',
          page: () => const PortalMpTrainingCourseCourseListScreen(),
          binding: PortalMpTrainingCourseCourseListBinding(),
        ),
        GetPage(
          name: '/PortalMpOpportunity',
          page: () => const PortalMpOpportunityScreen(),
          binding: PortalMpOpportunityBinding(),
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
          name: '/PurchaseProductList',
          page: () => const PurchaseProductListScreen(),
          binding: PurchaseProductListBinding(),
        ),
        GetPage(
          name: '/PurchasePriceList',
          page: () => const PurchasePriceListScreen(),
          binding: PurchasePriceListBinding(),
        ),
        GetPage(
          name: '/PurchaseOrder',
          page: () => const PurchaseOrderScreen(),
          binding: PurchaseOrderBinding(),
        ),
        GetPage(
          name: '/PurchaseRequest',
          page: () => const PurchaseRequestScreen(),
          binding: PurchaseRequestBinding(),
        ),
        GetPage(
          name: '/PurchaseRequestCreation',
          page: () => const PurchaseRequestCreationScreen(),
          binding: PurchaseRequestCreationBinding(),
        ),
        GetPage(
          name: '/PurchaseRequestCreationEdit',
          page: () => const PurchaseRequestCreationEditScreen(),
          binding: PurchaseRequestCreationEditBinding(),
        ),
        GetPage(
          name: '/PurchaseInvoice',
          page: () => const PurchaseInvoiceScreen(),
          binding: PurchaseInvoiceBinding(),
        ),
        GetPage(
          name: '/PurchaseContract',
          page: () => const PurchaseContractScreen(),
          binding: PurchaseContractBinding(),
        ),
        GetPage(
          name: '/PurchasePayment',
          page: () => const PurchasePaymentScreen(),
          binding: PurchasePaymentBinding(),
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
          name: '/SupplychainLoadUnload',
          page: () => const SupplychainLoadUnloadScreen(),
          binding: SupplychainLoadUnloadBinding(),
        ),
        GetPage(
          name: '/SupplychainLoadUnloadLine',
          page: () => const SupplychainLoadUnloadLineScreen(),
          binding: SupplychainLoadUnloadLineBinding(),
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
          name: '/SupplychainInventoryLine',
          page: () => const SupplychainInventoryLineScreen(),
          binding: SupplychainInventoryLineBinding(),
        ),
        GetPage(
          name: '/SupplychainInventoryLot',
          page: () => const SupplychainInventoryLotScreen(),
          binding: SupplychainInventoryLotBinding(),
        ),
        GetPage(
          name: '/SupplychainInventoryLotLine',
          page: () => const SupplychainInventoryLotLineScreen(),
          binding: SupplychainInventoryLotLineBinding(),
        ),
        GetPage(
          name: '/SupplychainMaterialreceipt',
          page: () => const SupplychainMaterialreceiptScreen(),
          binding: SupplychainMaterialreceiptBinding(),
        ),
        GetPage(
          name: '/SupplychainMaterialreceiptCreation',
          page: () => const SupplychainMaterialreceiptCreationScreen(),
          binding: SupplychainMaterialreceiptCreationBinding(),
        ),
        GetPage(
          name: '/SupplychainProductList',
          page: () => const SupplychainProductListScreen(),
          binding: SupplychainProductListBinding(),
        ),
        GetPage(
          name: '/SupplychainMaintenanceSwitchResourceScreen',
          page: () => const SupplychainMaintenanceSwitchResourceScreen(),
          binding: SupplychainMaintenanceSwitchResourceBinding(),
        ),
        GetPage(
          name: '/SupplychainMaintenanceLockUnlockContainerScreen',
          page: () => const SupplychainMaintenanceLockUnlockContainerScreen(),
          binding: SupplychainMaintenanceLockUnlockContainerBinding(),
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
          name: '/HumanResourceAttendance',
          page: () => const HumanResourceAttendanceScreen(),
          binding: HumanResourceAttendanceBinding(),
        ),
        GetPage(
          name: '/HumanResourceWorkHours',
          page: () => const HumanResourceWorkHoursScreen(),
          binding: HumanResourceWorkHoursBinding(),
        ),
        GetPage(
          name: '/HumanResourceEmployeeSheetScreen',
          page: () => const HumanResourceEmployeeSheetScreen(),
          binding: HumanResourceEmployeeSheetBinding(),
        ),
        GetPage(
          name: '/Employee',
          page: () => const EmployeeScreen(),
          binding: EmployeeBinding(),
        ),
        GetPage(
          name: '/EmployeeResource',
          page: () => const EmployeeResourceScreen(),
          binding: EmployeeResourceBinding(),
        ),
        GetPage(
          name: '/EmployeeResourceCalendarSlot',
          page: () => const EmployeeResourceCalendarSlotScreen(),
          binding: EmployeeResourceCalendarSlotBinding(),
        ),
        GetPage(
          name: '/EmployeeTicket',
          page: () => const EmployeeTicketScreen(),
          binding: EmployeeTicketBinding(),
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

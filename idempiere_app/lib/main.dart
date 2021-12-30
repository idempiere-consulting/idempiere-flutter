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
import 'package:idempiere_app/Screens/app/features/CRM_Product%20_List/views/screens/crm_product_list_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Sales_Order/views/screens/crm_sales_order_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Shipment/views/screens/crm_shipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/CRM_Task%20/views/screens/crm_task_screen.dart';
import 'package:idempiere_app/Screens/app/features/Calendar/views/screens/calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance/views/screens/maintenance_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Calendar/views/screens/maintenance_calendar_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Internaluseinventory/views/screens/maintenance_internaluseinventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpimportitem/views/screens/maintenance_mpimportitem_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpnomaly/views/screens/maintenance_mpanomaly_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mppicking/views/screens/maintenance_mppicking_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mptask/views/screens/maintenance_mptask_screen.dart';
import 'package:idempiere_app/Screens/app/features/Maintenance_Mpwarehouse/views/screens/maintenance_mpwarehouse_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp/views/screens/portal_mp_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Invoicepo/views/screens/portal_mp_invoicepo_screen.dart';
import 'package:idempiere_app/Screens/app/features/Portal_Mp_Portaloffer/views/screens/portal_mp_portaloffer_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase/views/screens/purchase_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Lead/views/screens/purchase_lead_screen.dart';
import 'package:idempiere_app/Screens/app/features/Purchase_Productwarehouseprice/views/screens/purchase_productwarehouseprice_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain/views/screens/supplychain_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Inventory/views/screens/supplychain_inventory_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Materialreceipt/views/screens/supplychain_materialreceipt_screen.dart';
import 'package:idempiere_app/Screens/app/features/Supplychain_Productwarehouse/views/screens/supplychain_productwarehouse_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket/views/screens/ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Customer_Ticket/views/screens/ticket_customer_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Resource_Assignment/views/screens/ticket_resource_assignment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Task/views/screens/ticket_task_screen.dart';
import 'package:idempiere_app/Screens/app/features/Ticket_Ticket/views/screens/ticket_ticket_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment/views/screens/vehicle_equipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Equipment/views/screens/vehicle_equipment_equipment_screen.dart';
import 'package:idempiere_app/Screens/app/features/Vehicle_Equipment_Vehicle/views/screens/vehicle_equipment_vehicle_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard/views/screens/dashboard_screen.dart';
//import 'package:idempiere_app/constants.dart';
import 'package:idempiere_app/Screens/Welcome/welcome_screen.dart';
import 'package:idempiere_app/Screens/app/features/dashboard_assetresource/views/screens/dashboard_assetresource_screen.dart';
import 'package:idempiere_app/localestrings.dart';

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
      translations: LocaleString(),
      locale: const Locale('it', 'IT'),
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
          name: '/Contatti',
          page: () => const CRMContactBPScreen(),
          binding: CRMContactBPBinding(),
        ),
        GetPage(
          name: '/Clienti',
          page: () => const CRMCustomerBPScreen(),
          binding: CRMCustomerBPBinding(),
        ),
        GetPage(
          name: '/Task&Appuntamenti',
          page: () => const CRMTaskScreen(),
          binding: CRMTaskBinding(),
        ),
        GetPage(
          name: '/Offerte',
          page: () => const CRMSalesOrderScreen(),
          binding: CRMSalesOrderBinding(),
        ),
        GetPage(
          name: '/ListinoProdotti',
          page: () => const CRMProductListScreen(),
          binding: CRMProductListBinding(),
        ),
        GetPage(
          name: '/Fattura',
          page: () => const CRMInvoiceScreen(),
          binding: CRMInvoiceBinding(),
        ),
        GetPage(
          name: '/Incassi',
          page: () => const CRMPaymentScreen(),
          binding: CRMPaymentBinding(),
        ),
        GetPage(
          name: '/Provvigioni',
          page: () => const CRMCommissionScreen(),
          binding: CRMCommissionBinding(),
        ),
        GetPage(
          name: '/Magazzino',
          page: () => const CRMShipmentScreen(),
          binding: CRMShipmentBinding(),
        ),
        GetPage(
          name: '/Ticket',
          page: () => const TicketScreen(),
          binding: TicketBinding(),
        ),
        GetPage(
          name: '/TicketTicket',
          page: () => const TicketTicketScreen(),
          binding: TicketTicketBinding(),
        ),
        GetPage(
          name: '/TicketCustomerTicket',
          page: () => const TicketCustomerTicketScreen(),
          binding: TicketCustomerTicketBinding(),
        ),
        GetPage(
          name: '/TicketTask',
          page: () => const TicketTaskScreen(),
          binding: TicketTaskBinding(),
        ),
        GetPage(
          name: '/TicketResourceAssignment',
          page: () => const TicketResourceAssignmentScreen(),
          binding: TicketResourceAssignmentBinding(),
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
          name: '/PurchaseOrderpo',
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

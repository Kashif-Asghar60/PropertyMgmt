import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Contracts/contract_form.dart';
import 'package:propertymgmt_uae/src/screens/Payment/printReceipts/payment_cheque.dart';
import 'package:propertymgmt_uae/src/screens/Payment/payment_view.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Currency%20Recipts/create_currencyRecipt.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Currency%20Recipts/information_currencyRecipt.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Financial%20Reports/content_navigation.dart';

import '../screens/Contracts/contract_information.dart';
import '../screens/Parties/Parties_Information.dart';
import '../screens/Payment/payment_create.dart';
import '../screens/Properties/property_information.dart';
import '../screens/Tenents/view_tenents.dart';
import '../screens/Units/units_information.dart';
import '../screens/Units/units_issued.dart';
import 'routeNames.dart';

class RouteSwitch extends StatelessWidget {
  const RouteSwitch({
    super.key,
    required this.routeName,
  });

  final String routeName;

  @override
  Widget build(BuildContext context) {
    switch (routeName) {
      case RouteStrings.dashboard:
       return Details_Currency_Reciept();
        //return  FinancialReportsMainContent();
      case RouteStrings.masterAccount:
        return const PartyInformationTable();
      case RouteStrings.rentals:
        return const PropertyInformationTable();
      case RouteStrings.leasing:
        return const Text("LeasingPage");
      case RouteStrings.tenants:
        return const TenantsInformationTable();

      case RouteStrings.reports:
        return const Text("Reports");
      case RouteStrings.tasks:
        return const Text("Tasks");
         case RouteStrings.payment:
        return const PaymentInformation(); 
      case RouteStrings.settings:
        return const Text("Settings");

      // other sub pages

      case RouteStrings.properties:
        return const PropertyInformationTable();
      case RouteStrings.unitIssued:
        return const UnitIssued();
      case RouteStrings.contracts:
        return const ContractInformation();
      case RouteStrings.units:
        return const UnitInformation();

      default:
        return const SizedBox();
    }
  }
}

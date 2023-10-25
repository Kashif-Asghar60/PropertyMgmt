import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:propertymgmt_uae/src/screens/Parties/Parties_Create.dart';
import 'package:propertymgmt_uae/src/screens/Parties/Parties_Information.dart';
import 'package:propertymgmt_uae/src/screens/Properties/property_create.dart';
import 'package:propertymgmt_uae/src/screens/Tenents/Create/Create_tenents.dart';
import 'package:propertymgmt_uae/src/screens/Properties/property_information.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_create.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_information.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_issued.dart';
import 'package:propertymgmt_uae/src/screens/Tenents/view_tenents.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_issued_create.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../screens/Contracts/contract_form.dart';
import '../screens/Contracts/contract_information.dart';

class ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<NavigationState>().selectedIndex;

    final List<Widget> contentWidgets = [
      Text("Dashboard"),
      Text(" Master Account"),
      Text("Rentals"),
      Text("Leasing"),
      Text("Tenants"),
      Text("Reports"),
      Text("Tasks"),
      Text("Settings"),
    ];

    return Container(
      height: Dimensions.screenHeight,
      color: AppConstants.content_areaClr,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: contentWidgets[selectedIndex],
      ),
    );
  }
}



/*  ContractCreateForm(),
      UnitsIssuedCreateForm(),
      UnitCreateForm(),
      PropertyCreateForm(),
      PartiesCreateForm(),
      // PartyInformationTable(),
      // UnitIssued(),
      //Text("Overview"),

      UnitInformation(),
      //  PropertyInformationTable(),
      ContractInformation(),
      TenentsInformationTable(),
      CreateTenants(), */
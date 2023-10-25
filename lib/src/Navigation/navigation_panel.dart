import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import 'widgets/navbutton.dart';

class NavigationPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
/*     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double iconSize = 1.5; // 3% of screen width
    double textSize = 1.4; // 3% of screen width
    double containerPadding = 1.0; // 1% of screen width
    double containerMargin = 1.0; // 1% of screen width
    double logoSize = 18.0; // 15% of screen width
 */
    double screenHeight = Dimensions.screenHeight;
    double logoSize = Dimensions.logoSize;
    return Container(
      height: screenHeight, // Set a fixed height based on screen height
      decoration: const BoxDecoration(
        color: AppConstants.purplethemecolor,
      ),
      child: ListView(
        // Use a ListView to efficiently handle the layout
        children: [
          // Image container
          Container(
            color: Colors.amberAccent,
            /*    margin: EdgeInsets.fromLTRB(
                0, 0.02 * screenHeight, 0, 0.01 * screenHeight), */
            width: logoSize,
            height: logoSize,
            child: Image.asset(
              'assets/logo.png',
            ),
          ),

          // Navigation buttons
          NavButton(
            text: 'Overview',
            icon: Icons.dashboard_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 0,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(0);
            },
          ),
          NavButton(
            text: 'Master Account',
            icon: Icons.account_balance_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 1,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(1);
            },
          ),
          NavButton(
            text: 'Rentals',
            icon: Icons.home_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 2,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(2);
            },
          ),
          NavButton(
            text: 'Leasing',
            icon: Icons.maps_home_work_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 3,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(3);
            },
          ),
          NavButton(
            text: 'Tenants',
            icon: Icons.room_preferences_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 4,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(4);
            },
          ),
          NavButton(
            text: 'Reports',
            icon: Icons.note_add_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 5,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(5);
            },
          ),
          NavButton(
            text: 'Tasks',
            icon: Icons.receipt_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 6,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(6);
            },
          ),
          NavButton(
            text: 'Settings',
            icon: Icons.settings_outlined,
            isSelected: context.watch<NavigationState>().selectedIndex == 7,
            onTap: () {
              context.read<NavigationState>().setSelectedIndex(7);
            },
          ),
        ],
      ),
    );
  }
}

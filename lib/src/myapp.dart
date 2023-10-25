import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
/* import 'package:responsive_framework/responsive_framework.dart';

import 'Navigation/content_area.dart';
import 'Navigation/navigation_panel.dart'; */
import 'Navigation/userprofilebar.dart';
import 'Navigation/widgets/navbutton.dart';
import 'Routes/NoRouteAnimation.dart';
import 'Routes/RightContentPanel.dart';
import 'Routes/routeNames.dart';
/* 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 640, name: MOBILE),
          const Breakpoint(start: 641, end: double.infinity, name: DESKTOP),
        ],
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                // Left Pane for Navigation
                SizedBox(
                  width: Dimensions.screenWidth * 0.2,
                  child: NavigationPanel(),
                ),
                // Main Content Area
                Expanded(
                  child: Column(
                    children: [
                      // Top Bar with User Profile Icons
                      UserProfileBar(),

                      // Navigation will be inside this Area
                      Expanded(
                        child: SingleChildScrollView(child: ContentArea()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
 */

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedMenu = 'Overview';
  String selectedSubMenu = '';
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final Map<String, List<String>> subMenus = {
    'Tenants': ['Tenants', 'UnitIssued', 'Contracts'],
    'Rentals': ['Properties', 'Units'],
    'MasterAccount': ['Parties'],
        '${RouteStrings.payment}': ['Payment'],

  };

  @override
  Widget build(BuildContext context) {
    double screenHeight = Dimensions.screenHeight;
   // double logoSize = Dimensions.logoSize;
    return Scaffold(
      body: Row(
        children: [
          // Blue and Red Containers (Left Navigation Panel)
          LeftNavigationPanel(screenHeight, context),
          // Green and Yellow Containers (Right Panel Content)
          Expanded(
            child: Column(
              children: [
                UserProfileBar(),
                RightContentPanel(
                    navigatorKey: _navigatorKey, selectedMenu: selectedMenu),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stack LeftNavigationPanel(double screenHeight, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Dimensions.screenWidth * 0.2,
          height: screenHeight,
          decoration: const BoxDecoration(
            color: AppConstants.purplethemecolor,
          ),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                // color: Colors.amberAccent,
                /*    margin: EdgeInsets.fromLTRB(
                0, 0.02 * screenHeight, 0, 0.01 * screenHeight), */
                width: Dimensions.logoSize,
                height: Dimensions.logoSize,
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
              SizedBox(
                height: Dimensions.buttonHeight,
              ),
              NavButton(
                text: RouteStrings.dashboard,
                icon: Icons.dashboard_outlined,
                isSelected: selectedMenu == RouteStrings.dashboard,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.dashboard;
                    selectedSubMenu = '';
                  });
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              NavButton(
                text: RouteStrings.masterAccount,
                icon: Icons.account_balance_outlined,
                isSelected: selectedMenu == RouteStrings.masterAccount,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.masterAccount;
                    selectedSubMenu = subMenus[RouteStrings.masterAccount]![0];
                  });
                  _navigatorKey.currentState!
                      .pushNamed(RouteStrings.masterAccount);
                },
              ),
              NavButton(
                text: RouteStrings.rentals,
                icon: Icons.home_outlined,
                isSelected: selectedMenu == RouteStrings.rentals,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.rentals;
                    selectedSubMenu = subMenus[RouteStrings.rentals]![0];
                    //  print(" vv $selectedSubMenu ");
                    //      selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  // sub page
                  _navigatorKey.currentState!
                      .pushNamed(RouteStrings.properties);
                },
              ),
              NavButton(
                text: RouteStrings.leasing,
                icon: Icons.maps_home_work_outlined,
                isSelected: selectedMenu == RouteStrings.leasing,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.leasing;
                    selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.leasing);
                },
              ),
              NavButton(
                text: RouteStrings.tenants,
                icon: Icons.room_preferences_outlined,
                isSelected: selectedMenu == RouteStrings.tenants,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.tenants;
                    selectedSubMenu = subMenus[RouteStrings.tenants]![0];

                    //   selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.tenants);
                },
              ),
              NavButton(
                text: RouteStrings.reports,
                icon: Icons.note_add_outlined,
                isSelected: selectedMenu == RouteStrings.reports,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.reports;
                    selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.reports);
                },
              ),
              NavButton(
                text: RouteStrings.tasks,
                icon: Icons.receipt_outlined,
                isSelected: selectedMenu == RouteStrings.tasks,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.tasks;
                    selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.tasks);
                },
              ),

              //payment
                      NavButton(
                text: RouteStrings.payment,
                icon: Icons.payment_outlined,
                isSelected: selectedMenu == RouteStrings.payment,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.payment;
                    selectedSubMenu = subMenus[RouteStrings.payment]![0];

                //    selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.payment);
                },
              ),
              NavButton(
                text: RouteStrings.settings,
                icon: Icons.settings_outlined,
                isSelected: selectedMenu == RouteStrings.settings,
                onTap: () {
                  setState(() {
                    selectedMenu = RouteStrings.settings;
                    selectedSubMenu = ''; // Reset selectedSubMenu
                  });
                  _navigatorKey.currentState!.pushNamed(RouteStrings.settings);
                },
              ),
            ],
          ),
        ),
        if (selectedMenu != RouteStrings.dashboard &&
            selectedMenu != RouteStrings.leasing &&
            selectedMenu != RouteStrings.reports &&
            selectedMenu != RouteStrings.tasks &&
            selectedMenu != RouteStrings.settings)
          Container(
            width: Dimensions.screenWidth * 0.2,
            height: screenHeight,
            decoration: BoxDecoration(
              color: AppConstants.purplethemecolor,
            ),
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  SizedBox(
                    // color: Colors.amberAccent,
                    /*    margin: EdgeInsets.fromLTRB(
                0, 0.02 * screenHeight, 0, 0.01 * screenHeight), */
                    width: Dimensions.logoSize,
                    height: Dimensions.logoSize,
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.buttonHeight,
                  ),
                  NavButton(
                      text: selectedMenu,
                      icon: Icons.arrow_back,
                      hideIcon: true,
                      backbuttonSize: false,
                      onTap: () {}),
                  ...subMenus[selectedMenu]!
                      .map((subMenuItem) => NavButton(
                            text: subMenuItem,
                            icon: Icons.arrow_forward,
                            isSelected: selectedSubMenu == subMenuItem,
                            onTap: () {
                              print(
                                  " 1.. $selectedSubMenu 2.. $subMenuItem   3..");
                              setState(() {
                                selectedSubMenu = subMenuItem;
                              });
                              // Pop the previous sub-page if it exists
                              /*   if (_navigatorKey.currentState!.canPop()) {
                                    _navigatorKey.currentState!.pop();
                                  }
                                  _navigatorKey.currentState!
                                      .pushNamed(subMenuItem); */
                              /*       Navigator.of(context).push(
                                      buildNoAnimationPageRoute(subMenuItem)); */

                              if (_navigatorKey.currentState!.canPop()) {
                                _navigatorKey.currentState!.pop();
                              }
                              _navigatorKey
                                ..currentState!.push(
                                    buildNoAnimationPageRoute(subMenuItem));
                            },
                          ))
                      .toList(),
                  NavButton(
                    text: 'Back',
                    icon: Icons.arrow_back,
                    backbuttonSize: true,
                    onTap: () {
                      setState(() {
                        selectedMenu = RouteStrings.dashboard;
                        selectedSubMenu = '';
                      });

                      _navigatorKey.currentState!
                          .popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

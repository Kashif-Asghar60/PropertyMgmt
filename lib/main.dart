/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/constants.dart';
import 'src/myapp.dart';
import 'src/providers/navigation_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationState(),
      child: Builder(
        builder: (BuildContext context) {
          Dimensions.init(context);
          // Pass the context to updateDimensions
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            updateDimensions(context);
          });

          return MyApp();
        },
      ),
    ),
  );
}

void updateDimensions(BuildContext context) {
  Dimensions.init(context);
  // You can also perform any additional logic here if needed
}
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:propertymgmt_uae/src/providers/dimensions_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'src/Routes/routeNames.dart';
import 'src/constants.dart';
import 'src/myapp.dart';
import 'src/providers/auth_provider.dart';
import 'src/screens/Contracts/contract_information.dart';
import 'src/screens/Login/login.dart';
import 'src/screens/Parties/Parties_Information.dart';
import 'src/screens/Properties/property_information.dart';
import 'src/screens/Reports/Financial Reports/content_navigation.dart';
import 'src/screens/Tenents/view_tenents.dart';
import 'src/screens/Units/units_information.dart';
import 'src/screens/Units/units_issued.dart'; // Import your home widget

void updateDimensions(BuildContext context) {
  final dimensionsProvider =
      Provider.of<DimensionsProvider>(context, listen: false);
  dimensionsProvider.init(context);

  Dimensions.init(context);
  // You can also perform any additional logic here if needed
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthProvider()), // Initialize AuthProvider
        ChangeNotifierProvider(create: (_) => DimensionsProvider()),

        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Builder(builder: (BuildContext context) {
        Dimensions.init(context);
        // Pass the context to updateDimensions
        WidgetsBinding.instance.addPostFrameCallback((_) {
          updateDimensions(context);
        });

        return StreamBuilder<bool>(
          // Use a Stream to determine when AuthProvider is initialized
          stream: Provider.of<AuthProvider>(context).initializationStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              // Get the screen width
              double screenWidth = MediaQuery.of(context).size.width;

              if (screenWidth >= 600) {
                // Show regular content for desktop (screen width >= 641 pixels)
                return MyApp();
              } else {
                // Show an error message for smaller screens
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: Text(
                        'ERROR: Please switch to a larger screen.',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              }
            } else {
              // Return a loading indicator or splash screen while waiting for initialization
              return const MaterialApp(
                home: Scaffold(
                  body: Center(
                    child:
                        CircularProgressIndicator(), // Show a loading indicator
                  ),
                ),
              );
            }
          },
        );
      }),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    print(
        "authProvider chk ${authProvider.isLoggedIn}...  ${authProvider.userId}... ${authProvider.rememberMe}");
    return MaterialApp(
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent)),
      )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Use the wrapper as the initial route
      routes: {
        '/': (context) => AuthWrapper(),
        RouteStrings.login: (context) => Login(),
        RouteStrings.home: (context) => MyHomePage(),

        RouteStrings.masterAccount: (context) =>
            const PartyInformationTable(), // Define the 'MasterAccount' route
        // Define routes for other screens here...

        RouteStrings.rentals: (context) => const PropertyInformationTable(),
        RouteStrings.leasing: (context) => const Text("LeasingPage"),
        RouteStrings.tenants: (context) => const TenantsInformationTable(),
        RouteStrings.reports: (context) => const Text("ReportsPage"),
        RouteStrings.tasks: (context) => const Text("TasksPage"),
        RouteStrings.settings: (context) => const Text("SettingsPage"),

// sub pages

        //
        RouteStrings.properties: (context) => const TenantsInformationTable(),

        RouteStrings.contracts: (context) => const ContractInformation(),
        //
        RouteStrings.unitIssued: (context) => const UnitIssued(),
        RouteStrings.units: (context) => const UnitInformation(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoggedIn) {
      // User is authenticated, navigate to the home screen
      return MyHomePage();
    } else {
      // User is not authenticated, navigate to the login screen
      return Login();
    }
  }
}

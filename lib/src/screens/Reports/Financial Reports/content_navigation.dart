import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Currency%20Recipts/create_currencyRecipt.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Journal%20Voucher/create_journal_voucher.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Journal%20Voucher/information_journal_voucher.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../widgets/CustomTextandFields/customTextField.dart';
import '../../../widgets/CustomTextandFields/dropdown.dart';
import '../../../widgets/customTextforfield.dart';

class FinancialReportsMainContent extends StatelessWidget {
  final double height = 10;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "GENERAL REPORTS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Statement of Accounts",
                        routeName: 'statementOfAccounts'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(text: "Audit Trail", routeName: 'auditTrail'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Account Comparison",
                        routeName: 'accountComparison'),
                    SizedBox(
                      height: height * 10,
                    ),
                    const Text(
                      "PARTY REPORTS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Account Balance", routeName: 'accountBalance'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Audit Trail", routeName: 'auditTrailParty'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Account Comparison",
                        routeName: 'accountComparisonParty'),
                    SizedBox(
                      height: height * 10,
                    ),
                    const Text(
                      "TAX REPORTS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "VAT Summary New", routeName: 'vatSummaryNew'),
                    SizedBox(
                      height: height,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "FINANCIAL REPORTS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Account Balance",
                        routeName: 'accountBalanceFinancial'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Trial Balance", routeName: 'trialBalance'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(
                        text: "Balance Sheet", routeName: 'balanceSheet'),
                    SizedBox(
                      height: height,
                    ),
                    _CustomText(text: "Profit & Loss", routeName: 'profitLoss'),
                    SizedBox(
                      height: height,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomText extends StatelessWidget {
  final String text;
  final String routeName;

  _CustomText({Key? key, required this.text, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Provider.of<NavigationProvider>(context, listen: false)
            .navigateToRoute(context, routeName);
      },
      child: AutoSizeText(
        text,
        style: const TextStyle(
          color: Color(0xFF2B3576),
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
          height: 0,
        ),
      ),
    );
  }
}

class NavigationProvider with ChangeNotifier {
  String? _currentRoute;

  String? get currentRoute => _currentRoute;

  void navigateToRoute(BuildContext context, String route) {
    _currentRoute = route;

    // Placeholder screens for navigation
    Widget screen = const SizedBox();

    if (route == 'statementOfAccounts') {
      screen = StatementOfAccountsScreen();
    } else if (route == 'auditTrail') {
      screen = AuditTrailScreen();
    } else if (route == 'accountComparison') {
      screen = Details_Journal_voucher();
    } else if (route == 'accountBalance') {
      screen = Create_CurrencyReciept();
    } else if (route == 'auditTrailParty') {
      screen = AuditTrailScreen();
    } else if (route == 'accountComparisonParty') {
      screen = AuditTrailScreen();
    } else if (route == 'vatSummaryNew') {
      screen = AuditTrailScreen();
    } else if (route == 'accountBalanceFinancial') {
      screen = AuditTrailScreen();
    } else if (route == 'trialBalance') {
      screen = AuditTrailScreen();
    } else if (route == 'balanceSheet') {
      screen = AuditTrailScreen();
    } else if (route == 'profitLoss') {
      screen = AuditTrailScreen();
    }

    // Use Navigator to navigate to the respective screen

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));

    notifyListeners();
  }
}

// Define your placeholder screens as needed
class StatementOfAccountsScreen extends StatefulWidget {
  @override
  State<StatementOfAccountsScreen> createState() =>
      _StatementOfAccountsScreenState();
}

class _StatementOfAccountsScreenState extends State<StatementOfAccountsScreen> {
  String? selectedVal;

  List<String> Items = [
    'AED',
    'USD',
    'EUR',
    'SAR',
    'PKR',
    'QAR',
    'OMR',
    'KWD',
    'BHD',
    'DZD',
    'EGP',
    'IQD',
    'JOD',
    'LBP',
    'LYD',
    'MAD',
    'SYP',
    'TND',
    'YER',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedVal = Items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstants.purplethemecolor,
          title: const Text("Statement of Accounts"),
        ),
        body: CustomFormContainer(
          heading: "",
          centerContent: [
            SizedBox(
              width: Dimensions.screenWidth / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 150,
                    child: CustomTextWidget(
                      text: "Account Code",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                  ),
                  const Spacer(),
                  CustomTextField(
                    width: Dimensions.widthTxtField / 2,
                    backgroundColor: AppConstants.whitecontainer,
                    /* controller: premiseNoController,
                          errorText: premiseNoErrorText, */
                  ),
                                    const SizedBox(width: 15,),

                  CustomTextField(
                    width: Dimensions.widthTxtField / 2,
                    backgroundColor: AppConstants.whitecontainer,
                    /* controller: premiseNoController,
                          errorText: premiseNoErrorText, */
                  ),
                ],
              ),
            ),
          const SizedBox(height: 13,),
            SizedBox(
              width: Dimensions.screenWidth / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomTextWidget(
                      text: "Date",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                  ),
                  const Spacer(),
                  CustomTextField(
                    width: Dimensions.widthTxtField / 2,
                    backgroundColor: AppConstants.whitecontainer,
                    /* controller: premiseNoController,
                          errorText: premiseNoErrorText, */
                  ),
                  const SizedBox(width: 15,),
                  CustomTextField(
                    width: Dimensions.widthTxtField / 2,
                    backgroundColor: AppConstants.whitecontainer,
                    /* controller: premiseNoController,
                          errorText: premiseNoErrorText, */
                  ),
                ],
              ),
            ),
                    const SizedBox(height: 13,),

            SizedBox(
              width: Dimensions.screenWidth / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width:   150,
                    child: CustomTextWidget(
                      text: "POS Customer",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                  ),
                  const Spacer(),
                  CustomTextField(
                    width: Dimensions.widthTxtField,
                    backgroundColor: AppConstants.whitecontainer,
                    /* controller: premiseNoController,
                          errorText: premiseNoErrorText, */
                  ),
                ],
              ),
            ),
                     const SizedBox(height: 13,),

            SizedBox(
              width: Dimensions.screenWidth / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomTextWidget(
                      text: "Currency",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                  ),
                  const Spacer(),
                  CustomDropdownTextField(
                    width: Dimensions.widthTxtField/2,
                    label: "",
                    items: Items,
                    value: selectedVal,
                    onChanged: (newValue) {
                      setState(() {
                        selectedVal = newValue;
                      });
                    },
                    backgroundColor: AppConstants.whitecontainer,
                  ),
                ],
              ),
            ),
          ],
          onCancel: () {},
          onSave: () {},
        ));
  }
}

class AuditTrailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audit Trail"),
      ),
      body: const Center(
        child: Text("This is the Audit Trail screen"),
      ),
    );
  }
}

// Add similar screen definitions for other routes
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Contracts/contract_form.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/CustomTextandFields/dropdown.dart';
import '../../widgets/customTextforfield.dart';
import '../../widgets/showdialog.dart';
import '../DropdownData/dropdownFBservices.dart';

class UnitsIssuedData {
  static const String tenantNameField = 'TenantName';
  static const String partyNameField = 'PartyName';
  static const String propertyNameField = 'PropertyName';
  static const String rentAmountField = 'RentAmount';
  static const String propertyField = 'Property';
  static const String advanceField = 'Advance';
  static const String unitField = 'Unit';
  static const String receiveAmountField = 'ReceiveAmount';
  static const String purposeField = 'Purpose';
  static const String balanceAmountField = 'BalanceAmount';

  final String tenantName;
  final String partyName;
  final String propertyName;
  final String rentAmount;
  final String property;
  final String advance;
  final String unit;
  final String receiveAmount;
  final String purpose;
  final String balanceAmount;

  UnitsIssuedData({
    required this.tenantName,
    required this.partyName,
    required this.propertyName,
    required this.rentAmount,
    required this.property,
    required this.advance,
    required this.unit,
    required this.receiveAmount,
    required this.purpose,
    required this.balanceAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      tenantNameField: tenantName,
      partyNameField: partyName,
      propertyNameField: propertyName,
      rentAmountField: rentAmount,
      propertyField: property,
      advanceField: advance,
      unitField: unit,
      receiveAmountField: receiveAmount,
      purposeField: purpose,
      balanceAmountField: balanceAmount,
    };
  }

  factory UnitsIssuedData.fromMap(Map<String, dynamic> map) {
    return UnitsIssuedData(
      tenantName: map[tenantNameField] ?? '',
      partyName: map[partyNameField] ?? '',
      propertyName: map[propertyNameField] ?? '',
      rentAmount: map[rentAmountField] ?? '',
      property: map[propertyField] ?? '',
      advance: map[advanceField] ?? '',
      unit: map[unitField] ?? '',
      receiveAmount: map[receiveAmountField] ?? '',
      purpose: map[purposeField] ?? '',
      balanceAmount: map[balanceAmountField] ?? '',
    );
  }
}

class UnitsIssuedCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const UnitsIssuedCreateForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<UnitsIssuedCreateForm> createState() => _UnitsIssuedCreateFormState();
}

class _UnitsIssuedCreateFormState extends State<UnitsIssuedCreateForm> {
  final TextEditingController rentAmountController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController receiveAmountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();
  UnitsIssuedData? unitobj;
/*   List<String> selectPartyItems = [
    'Party Name 1',
    'Party Name 2',
    'Party Name 3',
    'Party Name 4',
  ];
  List<String> selectPropertyNameItems = [
    'Property Name 1',
    'Property Name 2',
    'Property Name 3',
    'Property Name 4',
  ]; */
  List<String> selectPropertyItems = [
    'Property 1',
    'Property 2',
    'Property 3',
    'Property 4'
  ];
  List<String> unitTypeItems = [
    'unitType 1',
    'unitType 2',
    'unitType 3',
    'unitType 4'
  ];

  String? propertySelectedVal = "";
  String? propertyNameSelectedVal = "";
  String? partyNameSelectedVal = "";
  String? unitSelectedVal = "";
  String? tenantNameSelectedVal = "";

  @override
  void initState() {
    super.initState();
    propertySelectedVal = selectPropertyItems.first;
    /*   propertyNameSelectedVal = selectPropertyNameItems.first;
    partyNameSelectedVal = selectPartyItems.first; */
    unitSelectedVal = unitTypeItems.first;
    // Initialize errorText values to null for text fields
    tenantNameErrorText = null;
    rentAmountErrorText = null;
    advanceErrorText = null;
    receiveAmountErrorText = null;

    // for edit mode
    if (widget.initialData != null) {
      print("iinin data ${widget.initialData}");
      unitobj = UnitsIssuedData.fromMap(
          widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  }

  // Helper method to populate controllers from the tenant object
  void populateControllers() {
    tenantNameSelectedVal = unitobj?.tenantName ?? '';
    rentAmountController.text = unitobj?.rentAmount ?? '';
    advanceController.text = unitobj?.advance ?? '';
    receiveAmountController.text = unitobj?.receiveAmount ?? '';
    purposeController.text = unitobj?.purpose ?? '';
    balanceAmountController.text = unitobj?.balanceAmount ?? '';
    propertySelectedVal = unitobj?.property ?? '';
    propertyNameSelectedVal = unitobj?.propertyName ?? '';
    partyNameSelectedVal = unitobj?.partyName ?? '';
    unitSelectedVal = unitobj?.unit ?? '';
  }

  String? tenantNameErrorText;
  String? rentAmountErrorText;
  String? advanceErrorText;
  String? receiveAmountErrorText;

  void _saveDataToFirebase() {
    final tenantName = tenantNameSelectedVal;
    final partyName = partyNameSelectedVal;
    final propertyName = propertyNameSelectedVal;
    final rentAmount = rentAmountController.text;
    final property = propertySelectedVal;
    final advance = advanceController.text;
    final unit = unitSelectedVal;
    final receiveAmount = receiveAmountController.text;
    final purpose = purposeController.text;
    final balanceAmount = balanceAmountController.text;

    // Perform validation
    if (tenantName == null ||
        partyName == null ||
        propertyName == null ||
        rentAmount.isEmpty ||
        property == null ||
        advance.isEmpty ||
        unit == null ||
        receiveAmount.isEmpty) {
      // Set errorText values for text fields
      setState(() {
        tenantNameErrorText = tenantName == null ? 'Required field' : null;
        rentAmountErrorText = rentAmount.isEmpty ? 'Required field' : null;
        advanceErrorText = advance.isEmpty ? 'Required field' : null;
        receiveAmountErrorText =
            receiveAmount.isEmpty ? 'Required field' : null;
      });

      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Clear errorText values for text fields
    setState(() {
      tenantNameErrorText = null;
      rentAmountErrorText = null;
      advanceErrorText = null;
      receiveAmountErrorText = null;
    });

    unitobj = UnitsIssuedData(
      tenantName: tenantName,
      partyName: partyName,
      propertyName: propertyName,
      rentAmount: rentAmount,
      property: property,
      advance: advance,
      unit: unit,
      receiveAmount: receiveAmount,
      purpose: purpose,
      balanceAmount: balanceAmount,
    );

    // Replace with actual user ID
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final userId = user!.uid;

    final firebasePath = FirebaseFirestore.instance
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.unitIssued);
    // Create a map of data to upload
    final Map<String, dynamic> getData = unitobj!.toMap();

    if (widget.initialData != null) {
      final documentId = widget.initialData!['Document ID'];
      firebasePath.doc(documentId).update(getData);
      // Clear text field values

      rentAmountController.clear();
      advanceController.clear();
      receiveAmountController.clear();
      purposeController.clear();
      balanceAmountController.clear();
      setState(() {
        propertySelectedVal = selectPropertyItems.first;
        /*   propertyNameSelectedVal = selectPropertyNameItems.first;
        partyNameSelectedVal = selectPartyItems.first; */
        unitSelectedVal = unitTypeItems.first;
      });
      Navigator.of(context).pop();
      // Data uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data saved successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      firebasePath.add(getData).then((_) {
        Navigator.of(context).pop();
        showCustomDialog(context, const ContractCreateForm());
        // Data uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data saved successfully."),
            backgroundColor: Colors.green,
          ),
        );
        // Clear text field values
        rentAmountController.clear();
        advanceController.clear();
        receiveAmountController.clear();
        purposeController.clear();
        balanceAmountController.clear();
        setState(() {
          propertySelectedVal = selectPropertyItems.first;
          /*     propertyNameSelectedVal = selectPropertyNameItems.first;
        partyNameSelectedVal = selectPartyItems.first; */
          unitSelectedVal = unitTypeItems.first;
        });
      }).catchError((error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 8),
            content: Text("Error uploading data to Firebase: $error"),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();

        print('Error uploading data to Firebase: $error');
      });
    }
  }

  @override
  void dispose() {
    rentAmountController.dispose();
    advanceController.dispose();
    receiveAmountController.dispose();
    purposeController.dispose();
    balanceAmountController.dispose();
    super.dispose();
  }

  int height = 5;
  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(
      heading: "Tenants Details",
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSave: () {
        _saveDataToFirebase();

        /*     Navigator.of(dialogNavigatorKey.currentContext!).pushReplacement(
    MaterialPageRoute(
      builder: (context) => ContractCreateForm(),
    ),
  ); */
      },
      centerContent: [
        SizedBox(
          //color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            /*             mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start, */
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Tenant Name",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    //
                    /*  CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                         controller: tenantNameController,
          errorText:tenantNameErrorText,
       
                    ) // */
                    FutureBuilder(
                      future: FirebaseServices()
                          .fetchTenantNameItems(), // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          print("..${snapshot.error} ");
                          return Expanded(
                            child: AutoSizeText(
                              'Error: ${snapshot.error}',
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textScaleFactor: .7,
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data available',
                              overflow: TextOverflow
                                  .ellipsis); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                    final tenantInfoItems = snapshot.data!;
                    
      final tenantNames = tenantInfoItems.map((info) => info.name).toList();

      if (tenantNameSelectedVal == null || !tenantNames.contains(tenantNameSelectedVal)) {
        tenantNameSelectedVal = tenantNames.first;
      }

      return CustomDropdownTextField(
        width: Dimensions.widthTxtField,
        label: "",
        items: tenantNames,
        value: tenantNameSelectedVal,
        onChanged: (newValue) {
          setState(() {
            tenantNameSelectedVal = newValue;
            // Find the corresponding tenant ID for the selected name
         //   final selectedTenantInfo = tenantInfoItems.firstWhere((info) => info.name == newValue);
       //     final selectedTenantId = selectedTenantInfo.id;
            // Now, you can use selectedTenantId for saving.
          });
        },
        backgroundColor: AppConstants.whitecontainer,
      );
    }
  },
),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Party Name",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*   CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: selectPartyItems,
                        value: partyNameSelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            partyNameSelectedVal = newValue;
                          });
                        },
                          errorText: partyNameSelectedVal == null ? 'Required field' : null,

                        backgroundColor: AppConstants.whitecontainer), */
                    FutureBuilder<List<String>>(
                      future: FirebaseServices()
                          .fetchProjectPartyItems(), // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          print("..${snapshot.error} ");
                          return Text(
                            'Error: ${snapshot.error}',
                            overflow: TextOverflow.ellipsis,
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data available',
                              overflow: TextOverflow
                                  .ellipsis); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                          final Items = snapshot.data!
                              .toSet()
                              .toList(); // Remove duplicates

                          print("\n..  $Items\n ");

                          if (partyNameSelectedVal == null ||
                              !Items.contains(partyNameSelectedVal)) {
                            // Set a default value if it's null or not in the list
                            partyNameSelectedVal = Items.first;
                          }

                          return CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: Items,
                            value: partyNameSelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                partyNameSelectedVal = newValue;
                              });
                            },
                            backgroundColor: AppConstants.whitecontainer,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.sizeboxWidth * 8),

        /// Unit DEtails
        ///
        Text(
          "Unit Details",
          style: TextStyle(
            fontSize: Dimensions.textSize * 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Dimensions.sizeboxWidth * 6),

        /// property name and rent amount
        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Property Name",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*  CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: selectPropertyNameItems,
                        value: propertyNameSelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            propertyNameSelectedVal = newValue;
                          });
                        },
                          errorText: propertyNameSelectedVal == null ? 'Required field' : null,

                        backgroundColor: AppConstants.whitecontainer), */
                    FutureBuilder<List<String>>(
                      future: FirebaseServices()
                          .fetchPropertyNameItems(), // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          print("..${snapshot.error} ");
                          return Text(
                            'Error: ${snapshot.error}',
                            overflow: TextOverflow.ellipsis,
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data available',
                              overflow: TextOverflow
                                  .ellipsis); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                          final Items = snapshot.data!
                              .toSet()
                              .toList(); // Remove duplicates

                          print("\n..  $Items\n ");

                          if (propertyNameSelectedVal == null ||
                              !Items.contains(propertyNameSelectedVal)) {
                            // Set a default value if it's null or not in the list
                            propertyNameSelectedVal = Items.first;
                          }
                          return CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: Items,
                            value: propertyNameSelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                propertyNameSelectedVal = newValue;
                              });
                            },
                            backgroundColor: AppConstants.whitecontainer,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Rent Amount",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: rentAmountController,
                      errorText: rentAmountErrorText,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.sizeboxWidth * height),

        // property and advance
        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Property",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: selectPropertyItems,
                        value: propertySelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            propertySelectedVal = newValue;
                          });
                        },
                        errorText: propertySelectedVal == null
                            ? 'Required field'
                            : null,
                        backgroundColor: AppConstants.whitecontainer)
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Advance",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: advanceController,
                      errorText: advanceErrorText,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.sizeboxWidth * height),

        //unit  and receive amount
        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Unit",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*     CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: unitTypeItems,
                        value: unitSelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            unitSelectedVal = newValue;
                          });
                        },
                                                        errorText:unitSelectedVal==null ? 'Required field' : null,

                        backgroundColor: AppConstants.whitecontainer), */
                    FutureBuilder<List<String>>(
                      future: FirebaseServices()
                          .fetchUnitNameItems(), // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          print("..${snapshot.error} ");
                          return Text(
                            'Error: ${snapshot.error}',
                            overflow: TextOverflow.ellipsis,
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No data available',
                              overflow: TextOverflow
                                  .ellipsis); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                          final Items = snapshot.data!
                              .toSet()
                              .toList(); // Remove duplicates

                          print("\n..  $Items\n ");

                          if (unitSelectedVal == null ||
                              !Items.contains(unitSelectedVal)) {
                            // Set a default value if it's null or not in the list
                            unitSelectedVal = Items.first;
                          }
                          return CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: Items,
                            value: unitSelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                unitSelectedVal = newValue;
                              });
                            },
                            backgroundColor: AppConstants.whitecontainer,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Receive Amount",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: receiveAmountController,
                      errorText: receiveAmountErrorText,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.sizeboxWidth * height),

        /// purpose and balance amount
        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Purpose",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: false),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: purposeController,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Balance Amount",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: balanceAmountController,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

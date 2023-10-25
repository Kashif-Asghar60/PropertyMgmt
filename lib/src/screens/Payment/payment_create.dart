// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/CustomTextandFields/dropdown.dart';
import '../../widgets/customTextforfield.dart';
import '../DropdownData/dropdownFBservices.dart';
import '../Tenents/Data/model.dart';

class PaymentCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const PaymentCreateForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<PaymentCreateForm> createState() => _PaymentCreateFormState();
}

class _PaymentCreateFormState extends State<PaymentCreateForm> {
  List<String> selectPaymentMethodItems = [
    'Card',
    'Cheque',
    'Bank',
    'Payment Method 3',
    'Payment Method 4',
  ];

  //
  String? tenantNameSelectedVal = "";
  String? projectSelectedVal = "";
  String? unitNameSelectedVal = "";
  String? paymentMethodSelectedVal = "";
  TextEditingController collectionNoController = TextEditingController();
  TextEditingController collectionDateController = TextEditingController();
  TextEditingController chequeDateController = TextEditingController();
  TextEditingController chequeNoController = TextEditingController();
//TextEditingController unitNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController preBalanceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

/*   List<String> selectTenantItems = [
    'Tenant Name 1',
    'Tenant Name 2',
    'Tenant Name 3',
    'Tenant Name 4',
  ]; */

  /*  List<String> selectProjectItems = [
    'Project  1',
    'Project  2',
    'Project  3',
    'Project  4',
  ]; */
  int height = 5;
  PaymentCreateData? paymentData;

  String? collectionNoErrorText;
  String? collectionDateErrorText;
  String? chequeDateErrorText;
  String? chequeNoErrorText;
  String? unitNameErrorText;
  String? bankNameErrorText;
  String? preBalanceErrorText;
  String? discountErrorText;
  String? paidAmountErrorText;
  String? balanceErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*    tenantSelectedVal = selectTenantItems.first;
    projectSelectedVal=selectProjectItems.first;
 */

    paymentMethodSelectedVal = selectPaymentMethodItems.first;

    if (widget.initialData != null) {
      //print("iinin data ${widget.initialData}");
      paymentData = PaymentCreateData.fromMap(
          widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  }

  void populateControllers() {
    collectionNoController.text = paymentData?.collectionNo ?? "";
    collectionDateController.text = paymentData?.collectionDate ?? "";
    chequeDateController.text = paymentData?.chequeDate ?? "";
    chequeNoController.text = paymentData?.chequeNo ?? "";
    unitNameSelectedVal = paymentData?.unitName ?? "";

    bankNameController.text = paymentData?.bankName ?? "";
    preBalanceController.text = paymentData?.preBalance ?? "";
    discountController.text = paymentData?.discount ?? "";
    paidAmountController.text = paymentData?.paidAmount ?? "";

    balanceController.text = paymentData?.balance ?? "";
    tenantNameSelectedVal = paymentData?.tenantSelectedVal ?? "";
    projectSelectedVal = paymentData?.projectSelectedVal ?? "";
    paymentMethodSelectedVal = paymentData?.paymentMethodSelectedVal ?? "";
  }

  var selectedTenantId;
  void _saveDataToFirebase() {
    // Retrieve data from text controllers and fields
    final collectionNo = collectionNoController.text;
    final collectionDate = collectionDateController.text;
    final tenant = tenantNameSelectedVal ?? '';
    final project = projectSelectedVal ?? '';

    final paymentMethod = paymentMethodSelectedVal ?? '';
    final chequeDate = chequeDateController.text;
    final chequeNo = chequeNoController.text;
    final unitName = unitNameSelectedVal ?? "";

    final bankName = bankNameController.text;
    final preBalance = preBalanceController.text;
    final discount = discountController.text;
    final paidAmount = paidAmountController.text;
    final balance = balanceController.text;

    // Perform validation
    if (collectionNo.isEmpty ||
        collectionDate.isEmpty ||
        chequeDate.isEmpty ||
        chequeNo.isEmpty ||
        unitName.isEmpty ||
        bankName.isEmpty ||
        preBalance.isEmpty ||
        discount.isEmpty ||
        paidAmount.isEmpty ||
        balance.isEmpty) {
      // Set error messages
      setState(() {
        collectionNoErrorText = collectionNo.isEmpty ? 'Required field' : null;
        collectionDateErrorText =
            collectionDate.isEmpty ? 'Required field' : null;
        chequeDateErrorText = chequeDate.isEmpty ? 'Required field' : null;
        chequeNoErrorText = chequeNo.isEmpty ? 'Required field' : null;
        unitNameErrorText = unitName.isEmpty ? 'Required field' : null;
        bankNameErrorText = bankName.isEmpty ? 'Required field' : null;
        preBalanceErrorText = preBalance.isEmpty ? 'Required field' : null;
        discountErrorText = discount.isEmpty ? 'Required field' : null;
        paidAmountErrorText = paidAmount.isEmpty ? 'Required field' : null;
        balanceErrorText = balance.isEmpty ? 'Required field' : null;
      });

      // Show validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Clear any previous validation error messages
    setState(() {
      collectionNoErrorText = null;
      collectionDateErrorText = null;
      chequeDateErrorText = null;
      chequeNoErrorText = null;
      unitNameErrorText = null;
      bankNameErrorText = null;
      preBalanceErrorText = null;
      discountErrorText = null;
      paidAmountErrorText = null;
      balanceErrorText = null;
    });

    // Upload data to Firebase (Replace with your Firebase logic)
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final userId = user!.uid;
    final firebasePath = FirebaseFirestore.instance
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.payments);
    final getData = PaymentCreateData(
        selectedTenantId: selectedTenantId,
        tenantSelectedVal: tenant,
        projectSelectedVal: project,
        paymentMethodSelectedVal: paymentMethod,
        collectionNo: collectionNo,
        collectionDate: collectionDate,
        chequeDate: chequeDate,
        chequeNo: chequeNo,
        unitName: unitName,
        bankName: bankName,
        preBalance: preBalance,
        discount: discount,
        paidAmount: paidAmount,
        balance: balance);
    final Map<String, dynamic> paymentMap = getData.toMap();
                                    print("...IDDD  $selectedTenantId");


    if (widget.initialData != null) {
      final documentId = widget.initialData!['Document ID'];
      firebasePath.doc(documentId).update(paymentMap);
      // Clear text fields
      collectionNoController.clear();
      collectionDateController.clear();
      chequeDateController.clear();
      chequeNoController.clear();
      bankNameController.clear();
      preBalanceController.clear();
      discountController.clear();
      paidAmountController.clear();
      balanceController.clear();
      Navigator.of(context).pop();

      // Data uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data saved successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      firebasePath.add(paymentMap).then((_) {
        // Data uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data saved successfully."),
            backgroundColor: Colors.green,
          ),
        );
        // Clear text field values
        collectionNoController.clear();
        collectionDateController.clear();
        chequeDateController.clear();
        chequeNoController.clear();

        bankNameController.clear();
        preBalanceController.clear();
        discountController.clear();

        paidAmountController.clear();
        balanceController.clear();
        Navigator.of(context).pop();

        setState(() {
          // Reset dropdown selections if needed
          // Example:
          // contractTypeSelectedVal = selectContractTypeItems.first;
          // paymentPeriodSelectedVal = selectPaymentPeriodItems.first;
          // ... repeat for other dropdowns
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
        print('Error uploading data to Firebase: $error');
      });
    }
  }

  @override
  void dispose() {
    collectionNoController.dispose();
    collectionDateController.dispose();
    chequeDateController.dispose();
    chequeNoController.dispose();

    bankNameController.dispose();
    preBalanceController.dispose();
    discountController.dispose();

    paidAmountController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(
        heading: "Payment Details",
        onSave: () {
          _saveDataToFirebase();
        },
        centerContent: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collection No and Payment Type Heading
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
                              text: "Collection No",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: false),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: collectionNoController,
                            errorText: collectionNoErrorText,
                          ) //
                        ],
                      ),
                    ),
                    SizedBox(width: Dimensions.rowspaceBetweenTxtField),
                    SizedBox(
                      width: Dimensions.widthTxtField * 1.65,
                      child: Text(
                        "Payment Type",
                        style: TextStyle(
                          fontSize: Dimensions.textSize * 1.1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    /*   SizedBox(
                  width: Dimensions.widthTxtField * 1.65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: "Contract Type",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: selectContractTypeItems,
                          value: contractTypeSelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              contractTypeSelectedVal = newValue;
                            });
                          },
                          backgroundColor: AppConstants.whitecontainer),
                    ],
                  ),
                ), */
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * height),

              //Collection Date        Pay Method

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
                              text: "Collection Date",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: false),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: collectionDateController,
                            errorText: collectionDateErrorText,
                          ) //
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
                            text: "Pay Method",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          // dd
                          CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: selectPaymentMethodItems,
                            value: paymentMethodSelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                paymentMethodSelectedVal = newValue;
                              });
                            },
                            backgroundColor: AppConstants.whitecontainer,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //
              SizedBox(height: Dimensions.sizeboxWidth * height),
              //
              //Tenant Name*   Check Date*
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
                              text: "Tenant Name",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: false),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //dd
                          FutureBuilder<List<TenantInfo>>(
                            future: FirebaseServices()
                                .fetchTenantNameItems(), // Function to fetch project items
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Loading indicator while fetching data
                              } else if (snapshot.hasError) {
                                print("..${snapshot.error} ");
                                return SizedBox( 
                                  width: 100,
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    textScaleFactor:
                                        0.7, // Adjust the scale factor as needed
                                  ),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('No data available',
                                    overflow: TextOverflow
                                        .ellipsis); // Handle case where there is no data
                              } else {
                                final tenantInfoItems = snapshot.data!;
                               
                                final tenantNames = tenantInfoItems
                                    .map((info) => info.name)
                                    .toList();
                                print("...cv  $tenantNames");
                                if (tenantNameSelectedVal == null ||
                                    !tenantNames
                                        .contains(tenantNameSelectedVal)) {
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
                                      final selectedTenantInfo =
                                          tenantInfoItems.firstWhere(
                                              (info) => info.name == newValue);
                                      selectedTenantId = selectedTenantInfo.id;

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
                            text: "Cheque Date",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: chequeDateController,
                            errorText: chequeDateErrorText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //
              SizedBox(height: Dimensions.sizeboxWidth * height),
              //Project  (dd)   Check  No*
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
                              text: "Project",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: true),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          /*                      CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: selectProjectItems,
                            value: projectSelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                projectSelectedVal = newValue;
                              });
                            },
                            backgroundColor: AppConstants.whitecontainer,
                          ),
     */
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

                                if (projectSelectedVal == null ||
                                    !Items.contains(projectSelectedVal)) {
                                  // Set a default value if it's null or not in the list
                                  projectSelectedVal = Items.first;
                                }

                                return CustomDropdownTextField(
                                  width: Dimensions.widthTxtField,
                                  label: "",
                                  items: Items,
                                  value: projectSelectedVal,
                                  onChanged: (newValue) {
                                    setState(() {
                                      projectSelectedVal = newValue;
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
                            text: "Cheque No",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: chequeNoController,
                            errorText: chequeNoErrorText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //
              SizedBox(height: Dimensions.sizeboxWidth * height),

              //Unit Name*   Bank Name*
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
                          Expanded(
                            child: CustomTextWidget(
                                text: "Unit Name",
                                fontSize: Dimensions.Txtfontsize,
                                fontWeight: FontWeight.w500,
                                showStar: true),
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
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

                                if (unitNameSelectedVal == null ||
                                    !Items.contains(unitNameSelectedVal)) {
                                  // Set a default value if it's null or not in the list
                                  unitNameSelectedVal = Items.first;
                                }

                                return CustomDropdownTextField(
                                  width: Dimensions.widthTxtField,
                                  label: "",
                                  items: Items,
                                  value: unitNameSelectedVal,
                                  onChanged: (newValue) {
                                    setState(() {
                                      unitNameSelectedVal = newValue;
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
                            text: "Bank Name",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: bankNameController,
                            errorText: bankNameErrorText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //
              SizedBox(height: Dimensions.sizeboxWidth * height),

              // Pre Balance        Discount
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
                              text: "Pre Balance",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: false),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: preBalanceController,
                            errorText: preBalanceErrorText,
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
                            text: "Discount",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: false,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: discountController,
                            errorText: discountErrorText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * height),
              // paid Amount        Balance
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
                              text: "Paid Amount",
                              fontSize: Dimensions.Txtfontsize,
                              fontWeight: FontWeight.w500,
                              showStar: false),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: paidAmountController,
                            errorText: paidAmountErrorText,
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
                            text: "Balance",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: false,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField),
                          //
                          CustomTextField(
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            hintText: "",
                            controller: balanceController,
                            errorText: balanceErrorText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]);
  }
}

class PaymentCreateData {
  static const String tenantSelectedValField = 'tenantSelectedVal';
  static const String projectSelectedValField = 'projectSelectedVal';
  static const String paymentMethodSelectedValField =
      'paymentMethodSelectedVal';
  static const String collectionNoField = 'collectionNo';

  static const String collectionDateField = 'collectionDate';
  static const String checkDateField = 'checkDate';
  static const String checkNoField = 'checkNo';
  static const String unitNameField = 'unitName';

  static const String bankNameField = 'bankName';
  static const String preBalanceField = 'preBalance';
  static const String discountField = 'discount';
  static const String paidAmountField = "paidAmount";
  static const String balanceField = "balance";
  static const String selectedTenantIdField = "Tenant-ID";
  String? tenantSelectedVal;
  String? selectedTenantId;
  String? projectSelectedVal;
  String? paymentMethodSelectedVal;
  String? collectionNo;
  String? collectionDate;
  String? chequeDate;
  String? chequeNo;
  String? unitName;
  String? bankName;
  String? preBalance;
  String? discount;
  String? paidAmount;
  String? balance;

  PaymentCreateData(
      {required this.tenantSelectedVal,
      required this.selectedTenantId,
      required this.projectSelectedVal,
      required this.paymentMethodSelectedVal,
      required this.collectionNo,
      required this.collectionDate,
      required this.chequeDate,
      required this.chequeNo,
      required this.unitName,
      required this.bankName,
      required this.preBalance,
      required this.discount,
      required this.paidAmount,
      required this.balance});

  Map<String, dynamic> toMap() {
    return {
      tenantSelectedValField: tenantSelectedVal,
      projectSelectedValField: projectSelectedVal,
      paymentMethodSelectedValField: paymentMethodSelectedVal,
      collectionNoField: collectionNo,
      collectionDateField: collectionDate,
      checkDateField: chequeDate,
      checkNoField: chequeNo,
      unitNameField: unitName,
      bankNameField: bankName,
      preBalanceField: preBalance,
      discountField: discount,
      paidAmountField: paidAmount,
      balanceField: balance,
      selectedTenantIdField: selectedTenantId
    };
  }

  factory PaymentCreateData.fromMap(Map<String, dynamic> map) {
    return PaymentCreateData(
        selectedTenantId: map[selectedTenantIdField],
        tenantSelectedVal: map[tenantSelectedValField],
        projectSelectedVal: map[projectSelectedValField],
        paymentMethodSelectedVal: map[paymentMethodSelectedValField],
        collectionNo: map[collectionNoField],
        collectionDate: map[collectionDateField],
        chequeDate: map[checkDateField],
        chequeNo: map[checkNoField],
        unitName: map[unitNameField],
        bankName: map[bankNameField],
        preBalance: map[preBalanceField],
        discount: map[discountField],
        paidAmount: map[paidAmountField],
        balance: map[balanceField]);
  }
}

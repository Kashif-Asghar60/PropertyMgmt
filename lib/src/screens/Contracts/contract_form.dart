import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/CustomTextandFields/datapicker.dart';
import '../../widgets/CustomTextandFields/dropdown.dart';
import '../../widgets/customTextforfield.dart';

class ContractCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const ContractCreateForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<ContractCreateForm> createState() => _ContractCreateFormState();
}

class _ContractCreateFormState extends State<ContractCreateForm> {
  final TextEditingController contractNoController = TextEditingController();
  final TextEditingController contractValueController = TextEditingController();
  final TextEditingController annualRentController = TextEditingController();
  final TextEditingController securityDepositController = TextEditingController();
  final TextEditingController contractDurationController = TextEditingController();
  final TextEditingController gracePeriodController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();

  String? contractNoErrorText;
  String? contractTypeErrorText;
  String? issueDateErrorText;
  String? endDateErrorText;
  String? contractValueErrorText;
  String? annualRentErrorText;
  String? paymentPeriodErrorText;
  String? contractDurationErrorText;
  String? securityDepositErrorText;
  String? gracePeriodErrorText;
  String? paymentMethodErrorText;
  String? serviceAllowedErrorText;
  String? waterBillErrorText;
  ContractData? contractData;

  List<String> selectContractTypeItems = [
    'Contract Type 1',
    'Contract Type 2',
  ];
  List<String> selectPaymentPeriodItems = [
    'PaymentPeriod 1',
    'PaymentPeriod 2',
    'PaymentPeriod 3',
    'PaymentPeriod 4',
  ];
  List<String> selectServicesAllowedItems = [
    'ServicesAllowed 1',
    'ServicesAllowed 2',
    'ServicesAllowed 3',
    'ServicesAllowed 4',
  ];

  List<String> selectWaterElectricityBillItems = [
    'Water ElectricityBill 1',
    'Water ElectricityBill 2',
    'Water ElectricityBill 3',
    'Water ElectricityBill 4',
  ];
  String? contractTypeSelectedVal = "";
  String? paymentPeriodSelectedVal = "";

  String? servicesAllowedSelectedVal = "";
  String? waterElectricBillSelectedVal = "";

  DateTime? issueDate;
  DateTime? endDate;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contractTypeSelectedVal = selectContractTypeItems.first;
    paymentPeriodSelectedVal = selectPaymentPeriodItems.first;
    servicesAllowedSelectedVal = selectServicesAllowedItems
        .first; // Make sure this value matches one of the items in selectServicesAllowedItems
    waterElectricBillSelectedVal = selectWaterElectricityBillItems.first;
   if (widget.initialData != null) {
      //print("iinin data ${widget.initialData}");
     contractData =
          ContractData.fromMap(widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  }
    void populateControllers() {
 issueDateController.text= contractData?.issueDate??"";
 endDateController.text=contractData?.endDate??"";
    contractNoController.text = contractData?.contractNo??"";
    contractValueController.text = contractData?.contractValue??"";
    annualRentController.text = contractData?.annualRent??"";
    securityDepositController.text = contractData?.securityDeposit??"";
    contractDurationController.text = contractData?.contractDuration??"";
    gracePeriodController.text = contractData?.gracePeriod??"";
    paymentMethodController.text = contractData?.paymentMethod??"";
    contractTypeSelectedVal = contractData?.contractType??"";
    paymentPeriodSelectedVal= contractData?.paymentPeriod??"";
    servicesAllowedSelectedVal= contractData?.servicesAllowed??"";
    waterElectricBillSelectedVal= contractData?.waterElectricBill??"";
  }
    



  int height = 5;
  TextEditingController issueDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  // error strings
void _saveDataToFirebase() {
  // Retrieve data from text controllers and fields
  final contractNo = contractNoController.text;
  final contractType = contractTypeSelectedVal ?? '';
  final contractValue = contractValueController.text;
  final annualRent = annualRentController.text;
  final paymentPeriod = paymentPeriodSelectedVal ?? '';
  final securityDeposit = securityDepositController.text;
  final contractDuration = contractDurationController.text;
  final gracePeriod = gracePeriodController.text;
  final paymentMethod = paymentMethodController.text;
  final servicesAllowed = servicesAllowedSelectedVal ?? '';
  final waterElectricBill = waterElectricBillSelectedVal ?? '';
  final issueDatechk = issueDateController.text ;
  final endDatechk = endDateController.text;
  // Perform validation
  if (contractNo.isEmpty ||
      contractType.isEmpty ||
      issueDatechk.isEmpty ||
      endDatechk.isEmpty ||
      contractValue.isEmpty ||
      annualRent.isEmpty ||
      paymentPeriod.isEmpty ||
      securityDeposit.isEmpty ||
      contractDuration.isEmpty ||
      gracePeriod.isEmpty ||
      paymentMethod.isEmpty) {
   
    setState(() {
      contractNoErrorText = contractNo.isEmpty ? 'Required field' : null;
      contractTypeErrorText = contractType.isEmpty ? 'Required field' : null;
      issueDateErrorText = issueDate == null ? 'Required field' : null;
      endDateErrorText = endDate == null ? 'Required field' : null;
      contractValueErrorText = contractValue.isEmpty ? 'Required field' : null;
      annualRentErrorText = annualRent.isEmpty ? 'Required field' : null;
      paymentPeriodErrorText = paymentPeriod.isEmpty ? 'Required field' : null;
      securityDepositErrorText = securityDeposit.isEmpty ? 'Required field' : null;
      contractDurationErrorText = contractDuration.isEmpty ? 'Required field' : null;
      gracePeriodErrorText = gracePeriod.isEmpty ? 'Required field' : null;
      paymentMethodErrorText = paymentMethod.isEmpty ? 'Required field' : null;
      serviceAllowedErrorText = servicesAllowed.isEmpty ? 'Required field' : null;
      waterBillErrorText= waterElectricBill.isEmpty ? 'Required field' : null;
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
    contractNoErrorText = null;
    contractTypeErrorText = null;
    issueDateErrorText = null;
    endDateErrorText = null;
    contractValueErrorText = null;
    annualRentErrorText = null;
    paymentPeriodErrorText = null;
    securityDepositErrorText = null;
    contractDurationErrorText = null;
    gracePeriodErrorText = null;
    paymentMethodErrorText = null;
    serviceAllowedErrorText= null;
    waterBillErrorText= null;
    
  });

  contractData = ContractData(
    contractNo: contractNo,
    contractType: contractType,
    issueDate: issueDatechk,
    endDate: endDatechk,
    contractValue: contractValue,
    annualRent: annualRent,
    paymentPeriod: paymentPeriod,
    securityDeposit: securityDeposit,
    contractDuration: contractDuration,
    gracePeriod: gracePeriod,
    paymentMethod: paymentMethod,
    servicesAllowed: servicesAllowed,
    waterElectricBill: waterElectricBill,
  );

  // Upload data to Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final userId = user!.uid;
  final firebasePath = FirebaseFirestore.instance
      .collection(FirebaseConstants.users)
      .doc(userId)
      .collection(FirebaseConstants.contracts);
      final Map<String, dynamic> getData = contractData!.toMap() ;
if(widget.initialData != null){
      final documentId = widget.initialData![
            'Document ID']; 
        firebasePath.doc(documentId).update(getData);
        contractNoController.clear();
        contractValueController.clear();
        annualRentController.clear();
        securityDepositController.clear();
        contractDurationController.clear();
        gracePeriodController.clear();
        paymentMethodController.clear();
        issueDateController.clear();
        endDateController.clear();
        Navigator.of(context).pop();

      // Data uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data saved successfully."),
          backgroundColor: Colors.green,
        ),
      );
}else {
  firebasePath
      .add(getData)
      .then((_) {
        // Data uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
       const   SnackBar(
            content: Text("Data saved successfully."),
            backgroundColor: Colors.green,
          ),
        );
        // Clear text field values
        contractNoController.clear();
        contractValueController.clear();
        annualRentController.clear();
        securityDepositController.clear();
        contractDurationController.clear();
        gracePeriodController.clear();
        paymentMethodController.clear();
         issueDateController.clear();
        endDateController.clear();
                Navigator.of(context).pop();

        setState(() {

          // Reset dropdown selections if needed
          // Example:
          // contractTypeSelectedVal = selectContractTypeItems.first;
          // paymentPeriodSelectedVal = selectPaymentPeriodItems.first;
          // ... repeat for other dropdowns
        });
      })
      .catchError((error) {
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
  contractNoController.dispose();
  contractValueController.dispose();
  annualRentController.dispose();
  securityDepositController.dispose();
  contractDurationController.dispose();
  gracePeriodController.dispose();
  paymentMethodController.dispose();
   issueDateController.dispose();
        endDateController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(heading: "Contract Details",
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSave: () {
        _saveDataToFirebase();
      },
     centerContent: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contract No and Contract Type
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
                          text: "Contract No",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      //
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: contractNoController,
                        errorText: contractNoErrorText,
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
                          errorText: contractTypeErrorText,
                          backgroundColor: AppConstants.whitecontainer),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * height),

          //Issue Date*         End Date*

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
                          text: "Issue Date",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      //
                      CustomDatePickerTextField(
                        width: Dimensions.widthTxtField,
                        labelText: 'Select Date',
                        controller: issueDateController
                        ,
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
                        text: "End Date",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDatePickerTextField(
                        width: Dimensions.widthTxtField,
                        labelText: 'Select Date',
                        controller: endDateController,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

//
          SizedBox(height: Dimensions.sizeboxWidth * height),
//
//Contract Value *   Annual Rent*
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
                          text: "Contract Value",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: false),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: contractValueController,
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
                        text: "Annual Rent",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: annualRentController,
                        errorText: annualRentErrorText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

//
          SizedBox(height: Dimensions.sizeboxWidth * height),
//Payment Period * (dd)   Security Deposit*
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
                          text: "Payment Period",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: selectPaymentPeriodItems,
                          value: paymentPeriodSelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              paymentPeriodSelectedVal = newValue;
                            });
                          },
                          errorText: paymentPeriodErrorText,
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
                        text: "Security Deposit",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: securityDepositController,
                        errorText: securityDepositErrorText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

//
          SizedBox(height: Dimensions.sizeboxWidth * height),

//Contract Duration *    Grace Period*
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
                            text: "Contract Duration",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true),
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: contractDurationController,
                        errorText: contractDurationErrorText,
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
                        text: "Grace Period",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: gracePeriodController,
                        errorText: gracePeriodErrorText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

//
          SizedBox(height: Dimensions.sizeboxWidth * height),
// Payment Method *      Services Allowed* (dd)
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
                          text: "Payment Method",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      //
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: paymentMethodController,
                        errorText: paymentMethodErrorText,
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
                        text: "Services Allowed",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: selectServicesAllowedItems,
                          value: servicesAllowedSelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              servicesAllowedSelectedVal = newValue;
                            });
                          },
                          errorText: serviceAllowedErrorText,
                          //
                          backgroundColor: AppConstants.whitecontainer),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Dimensions.sizeboxWidth * height),
//Water/Electricity Bill *   (drpdown)

          SizedBox(
            // color: Colors.amberAccent,
            width: Dimensions.widthTxtField * 1.6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  text: "Water/Electricity \nBill",
                  fontSize: Dimensions.Txtfontsize,
                  fontWeight: FontWeight.w500,
                  showStar: true,
                ),
                //  SizedBox(width: Dimensions.spaceBetweenTxtField / .7),
                CustomDropdownTextField(
                    width: Dimensions.widthTxtField,
                    label: "",
                    items: selectWaterElectricityBillItems,
                    value: waterElectricBillSelectedVal,
                    onChanged: (newValue) {
                      setState(() {
                        waterElectricBillSelectedVal = newValue;
                      });
                    },
                    errorText: waterBillErrorText,
                    backgroundColor: AppConstants.whitecontainer),
              ],
            ),
          ),
        ],
      )
    ]);
  }
}






class ContractData {
  static const String contractNoField = 'ContractNo';
  static const String contractTypeField = 'ContractType';
  static const String issueDateField = 'IssueDate';
  static const String endDateField = 'EndDate';
  static const String contractValueField = 'ContractValue';
  static const String annualRentField = 'AnnualRent';
  static const String paymentPeriodField = 'PaymentPeriod';
  static const String securityDepositField = 'SecurityDeposit';
  static const String contractDurationField = 'ContractDuration';
  static const String gracePeriodField = 'GracePeriod';
  static const String paymentMethodField = 'PaymentMethod';
  static const String servicesAllowedField = 'ServicesAllowed';
  static const String waterElectricBillField = 'WaterElectricBill';

  final String contractNo;
  final String contractType;
  final String issueDate;
  final String endDate;
  final String contractValue;
  final String annualRent;
  final String paymentPeriod;
  final String securityDeposit;
  final String contractDuration;
  final String gracePeriod;
  final String paymentMethod;
  final String servicesAllowed;
  final String waterElectricBill;

  ContractData({
    required this.contractNo,
    required this.contractType,
    required this.issueDate,
    required this.endDate,
    required this.contractValue,
    required this.annualRent,
    required this.paymentPeriod,
    required this.securityDeposit,
    required this.contractDuration,
    required this.gracePeriod,
    required this.paymentMethod,
    required this.servicesAllowed,
    required this.waterElectricBill,
  });

  Map<String, dynamic> toMap() {
    return {
      contractNoField: contractNo,
      contractTypeField: contractType,
      issueDateField: issueDate,
      endDateField: endDate,
      contractValueField: contractValue,
      annualRentField: annualRent,
      paymentPeriodField: paymentPeriod,
      securityDepositField: securityDeposit,
      contractDurationField: contractDuration,
      gracePeriodField: gracePeriod,
      paymentMethodField: paymentMethod,
      servicesAllowedField: servicesAllowed,
      waterElectricBillField: waterElectricBill,
    };
  }

  factory ContractData.fromMap(Map<String, dynamic> map) {
    return ContractData(
      contractNo: map[contractNoField] ?? '',
      contractType: map[contractTypeField] ?? '',
      issueDate:map[issueDateField] ?? '',
      endDate: map[endDateField] ?? '',
      contractValue: map[contractValueField] ?? '',
      annualRent: map[annualRentField] ?? '',
      paymentPeriod: map[paymentPeriodField] ?? '',
      securityDeposit: map[securityDepositField] ?? '',
      contractDuration: map[contractDurationField] ?? '',
      gracePeriod: map[gracePeriodField] ?? '',
      paymentMethod: map[paymentMethodField] ?? '',
      servicesAllowed: map[servicesAllowedField] ?? '',
      waterElectricBill: map[waterElectricBillField] ?? '',
    );
  }
}

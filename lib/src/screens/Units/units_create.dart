import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Contracts/contract_form.dart';
import 'package:propertymgmt_uae/src/screens/DropdownData/dropdownFBservices.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/dropdown.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/customTextforfield.dart';
import '../../widgets/showdialog.dart';

class UnitCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const UnitCreateForm({Key? key, this.initialData}) : super(key: key);

  @override
  State<UnitCreateForm> createState() => _UnitCreateFormState();
}

class _UnitCreateFormState extends State<UnitCreateForm> {

  List<String> selectPropertyItems = [
    'Property 1',
    'Property 2',
    'Property 3',
    'Property 4',
  ];

  List<String> unitStatusItems = [
    'Available',
    'Not Available',
  ];
  List<String> unitTypeItems = [
    'unitType 1',
    'unitType 2',
    'unitType 3',
    'unitType 4',
  ];
  UnitFormData? objData;
  // Controllers for text fields
  final TextEditingController premiseNoController = TextEditingController();
  final TextEditingController unitSizeController = TextEditingController();
  final TextEditingController unitNoController = TextEditingController();
  final TextEditingController rentAmountController = TextEditingController();
  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController occupiedNoController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController remarksController= TextEditingController();

  String? propertySelectedVal = "";
  String? unitStatusSelectedVal = "";
  String? unitTypeSelectedVal = "";
 // Error text strings for fields with showStar true
  String? premiseNoErrorText;
  String? propertyErrorText;
  String? unitNoErrorText;
  String? unitStatusErrorText;
  String? unitTypeErrorText;
  String? rentAmountErrorText;
  String? occupiedNoErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    propertySelectedVal = selectPropertyItems.first;
    unitStatusSelectedVal = unitStatusItems.first;
    unitTypeSelectedVal = unitTypeItems.first;

     if (widget.initialData != null) {
      print("iininvxv data ${widget.initialData}");
     objData =
          UnitFormData.fromMap(widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  
  }
  void populateControllers() {
  premiseNoController.text = objData?.premiseNo ?? "";
  lengthController.text =objData?.length??"";
  widthController.text= objData?.width??"";
  propertySelectedVal = objData?.property ?? "";
  unitSizeController.text = objData?.unitSize ?? "";
  unitNoController.text = objData?.unitNo ?? "";
  unitStatusSelectedVal = objData?.unitStatus ?? "";
  unitTypeSelectedVal = objData?.unitType ?? "";
  rentAmountController.text = objData?.rentAmount ?? "";
  unitNameController.text = objData?.unitName ?? "";
  occupiedNoController.text = objData?.occupiedNo ?? "";
  remarksController.text = objData?.remarks ?? "";

}

void _saveDataToFirebase( BuildContext ctx) {
  // Retrieve data from text controllers and fields
  final premiseNo = premiseNoController.text;
  final unitSize = unitSizeController.text;
  final unitNo = unitNoController.text;
  final rentAmount = rentAmountController.text;
  final unitName = unitNameController.text;
  final occupiedNo = occupiedNoController.text;
  final length = lengthController.text;
  final width = widthController.text;
  final remarks = remarksController.text; // Added remarks field
  final property = propertySelectedVal ?? '';
  final unitStatus = unitStatusSelectedVal ?? '';
  final unitType = unitTypeSelectedVal ?? '';

print( "${premiseNo  } $unitSize $unitNo $rentAmount  $unitName  $occupiedNo $length $width $remarks $property  $unitStatus $unitType"); 
/*   // Create components for addressCombined
  final components = [
    if (property.isNotEmpty) 'Property: $property',
    if (length.isNotEmpty) 'Length: $length',
    if (width.isNotEmpty) 'Width: $width',
  ];

  final addressCombined = components.isNotEmpty ? components.join(' ') : '';
 */
  // Perform validation for fields where showStar is true
  if (premiseNo.isEmpty ||
      property.isEmpty ||
      unitNo.isEmpty ||
      unitStatus.isEmpty ||
      unitType.isEmpty ||
      rentAmount.isEmpty ||
      occupiedNo.isEmpty 
     ) { // Check for remarks field
    setState(() {
      premiseNoErrorText = premiseNo.isEmpty ? 'Required field' : null;
      propertyErrorText = property.isEmpty ? 'Required field' : null;
      unitNoErrorText = unitNo.isEmpty ? 'Required field' : null;
      unitStatusErrorText = unitStatus.isEmpty ? 'Required field' : null;
      unitTypeErrorText = unitType.isEmpty ? 'Required field' : null;
      rentAmountErrorText = rentAmount.isEmpty ? 'Required field' : null;
      occupiedNoErrorText = occupiedNo.isEmpty ? 'Required field' : null;
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
    premiseNoErrorText = null;
    propertyErrorText = null;
    unitNoErrorText = null;
    unitStatusErrorText = null;
    unitTypeErrorText = null;
    rentAmountErrorText = null;
    occupiedNoErrorText = null;
  });

  // Create a UnitFormData object
  final unitFormData = UnitFormData(
    premiseNo: premiseNo,
    unitSize: unitSize,
    unitNo: unitNo,
    rentAmount: rentAmount,
    unitName: unitName,
    occupiedNo: occupiedNo,
    length: length,
    width: width,
    property: property,
    unitStatus: unitStatus,
    unitType: unitType,
    remarks: remarks, // Added remarks field
 //   addressCombined: addressCombined,
  );

  // Upload data to Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final userId = user!.uid;
  final firebasePath = FirebaseFirestore.instance.collection(FirebaseConstants.users).doc(userId).collection(FirebaseConstants.rentalUnits);
  final Map<String, dynamic> unitFormDataMap = unitFormData.toMap();

  if (widget.initialData != null) {
    final documentId = widget.initialData!['Document ID'];
    firebasePath.doc(documentId).update(unitFormDataMap);

    // Clear text field values
    premiseNoController.clear();
    unitSizeController.clear();
    unitNoController.clear();
    rentAmountController.clear();
    unitNameController.clear();
    occupiedNoController.clear();
    lengthController.clear();
    widthController.clear();
    remarksController.clear(); // Clear remarks field
   Navigator.of(context).pop();

    // Data updated successfully
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data updated successfully."),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    firebasePath.add(unitFormDataMap).then((_) {
      // Data uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data saved successfully."),
          backgroundColor: Colors.green,
        ),
      );
      // Clear text field values
      premiseNoController.clear();
      unitSizeController.clear();
      unitNoController.clear();
      rentAmountController.clear();
      unitNameController.clear();
      occupiedNoController.clear();
      lengthController.clear();
      widthController.clear();
      remarksController.clear(); // Clear remarks field
    Navigator.of(context).pop();
  
      setState(() {
        // Reset dropdown selections if needed
        // Example:
        // propertySelectedVal = selectPropertyItems.first;
        // unitStatusSelectedVal = unitStatusItems.first;
        // unitTypeSelectedVal = unitTypeItems.first;
      });

    }
    ).catchError((error) {
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
  // Dispose of TextEditingController instances to prevent memory leaks
  premiseNoController.dispose();
  unitSizeController.dispose();
  unitNoController.dispose();
  rentAmountController.dispose();
  unitNameController.dispose();
  occupiedNoController.dispose();
  lengthController.dispose();
  widthController.dispose();
  remarksController.dispose();
  super.dispose();
}



  int height = 5;
  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(heading: "Unit Details", 
    onSave: () {
       _saveDataToFirebase( context);
    
    },
    
    centerContent: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Dimensions.screenWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  //color: Colors.amber,
                  width: Dimensions.widthTxtField * 1.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: "Premise No",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        controller: premiseNoController,
                        errorText: premiseNoErrorText,
                      ),
                    ],
                  ),
                ),

                ///            L W
                SizedBox(
                  //  color: Colors.greenAccent,
                  width: Dimensions.screenWidth / 2,
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          // color: Colors.red,
                          // height: 60,
                          width: Dimensions.widthTxtField),
                      CustomTextField(
                        hintText: "L",
                        width: Dimensions.widthTxtField / 2.3,
                        backgroundColor: AppConstants.whitecontainer,
                        controller: lengthController,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                      CustomTextField(
                        hintText: "W",
                        width: Dimensions.widthTxtField / 2.3,
                        backgroundColor: AppConstants.whitecontainer,
                        controller: widthController,
                      ),
                      //    SizedBox(width: Dimensions.spaceBetweenTxtField / 2),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // select property and sq ft
          SizedBox(height: Dimensions.sizeboxWidth * height),

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
                          text: "Select Property",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                 /*      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: selectPropertyItems,
                          value: propertySelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              propertySelectedVal = newValue;
                            });
                          },
                          errorText: propertyErrorText,
                          backgroundColor: AppConstants.whitecontainer),
                            */  FutureBuilder<List<String>>(
                      future:
                          FirebaseServices().fetchPropertyNameItems(), // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          print("..${snapshot.error} ");
                          return Text('Error: ${snapshot.error}', overflow: TextOverflow.ellipsis,);
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text(
                              'No data available',overflow: TextOverflow.ellipsis); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                         final Items = snapshot.data!.toSet().toList(); // Remove duplicates

                          print("\n..  $Items\n ");
                 
                               if (propertySelectedVal == null ||
          !Items.contains(propertySelectedVal)) {
        // Set a default value if it's null or not in the list
        propertySelectedVal = Items.first;
      }
                          return CustomDropdownTextField(
                            width: Dimensions.widthTxtField,
                            label: "",
                            items: Items,
                            value: propertySelectedVal,
                            onChanged: (newValue) {
                              setState(() {
                                propertySelectedVal = newValue;
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
                        text: "Unit Size (Sq Ft)",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: false,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: unitSizeController,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * height),

          //   Unit no and statue //////////////////////
          SizedBox(
            // color: Colors.yellow,
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
                          text: "Unit No.",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: unitNoController,
                        errorText: unitNoErrorText,
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
                        text: "Unit Status",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: unitStatusItems,
                          value: unitStatusSelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              unitStatusSelectedVal = newValue;
                            });
                          },
                          errorText: unitStatusErrorText,
                          backgroundColor: AppConstants.whitecontainer)
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * height),

          //////// Unit type and Rent amount*
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
                          text: "Unit Type",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomDropdownTextField(
                          width: Dimensions.widthTxtField,
                          label: "",
                          items: unitTypeItems,
                          value: unitTypeSelectedVal,
                          onChanged: (newValue) {
                            setState(() {
                              unitTypeSelectedVal = newValue;
                            });
                          },
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
///////// Unit Name and Occupied NO
          SizedBox(
            // color: Colors.yellow,
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
                          text: "Unit Name",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: false),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: unitNameController,
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
                        text: "Occupied No",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true,
                      ),
                      SizedBox(width: Dimensions.spaceBetweenTxtField),
                      CustomTextField(
                        width: Dimensions.widthTxtField,
                        backgroundColor: AppConstants.whitecontainer,
                        hintText: "",
                        controller: occupiedNoController,
                        errorText: occupiedNoErrorText,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * height),
             SizedBox(
            height: Dimensions.buttonHeight * 1.4,
            child: CustomTextField(
              maxLines: 4,
              width: Dimensions.widthTxtField * 5,
              backgroundColor: AppConstants.whitecontainer,
              hintText: "Remarks",
              controller: remarksController, // Address controller
             
            ),
          ),
        ],
      ),
    ]);
  }

}


class UnitFormData {
  static const String premiseNoField = 'PremiseNo';
    static const String lengthField = 'Length';
  static const String widthField = 'Width';
    static const String propertyField = 'Property';

  static const String unitSizeField = 'UnitSize';
  static const String unitNoField = 'UnitNo';
  static const String unitStatusField = 'UnitStatus';
  static const String unitTypeField = 'UnitType';
  static const String rentAmountField = 'RentAmount';
  static const String unitNameField = 'UnitName';
  static const String occupiedNoField = 'OccupiedNo';
  static const String remarksField = 'Remarks';


  final String premiseNo;
  final String property;
  final String unitSize;
  final String unitNo;
  final String unitStatus;
  final String unitType;
  final String rentAmount;
  final String unitName;
  final String occupiedNo;
  final String length;
  final String width;
  final String remarks;

  UnitFormData({
    required this.premiseNo,
    required this.property,
    required this.unitSize,
    required this.unitNo,
    required this.unitStatus,
    required this.unitType,
    required this.rentAmount,
    required this.unitName,
    required this.occupiedNo,
    required this.length,
    required this.width,
    required this.remarks
  });

  Map<String, dynamic> toMap() {
    return {
      premiseNoField: premiseNo,
      propertyField:property,
      unitSizeField: unitSize,
      unitNoField: unitNo,
      unitStatusField: unitStatus,
      unitTypeField: unitType,
      rentAmountField: rentAmount,
      unitNameField: unitName,
      occupiedNoField: occupiedNo,
      lengthField: length,
      widthField: width,
      remarksField:remarks
    };
  }

  factory UnitFormData.fromMap(Map<String, dynamic> map) {
    return UnitFormData(
      premiseNo: map[premiseNoField] ?? '',
            property: map[propertyField] ?? '',

      unitSize: map[unitSizeField] ?? '',
      unitNo: map[unitNoField] ?? '',
      unitStatus: map[unitStatusField] ?? '',
      unitType: map[unitTypeField] ?? '',
      rentAmount: map[rentAmountField] ?? '',
      unitName: map[unitNameField] ?? '',
      occupiedNo: map[occupiedNoField] ?? '',
      length: map[lengthField] ?? '',
      width: map[widthField] ?? '',
      remarks: map[remarksField] ?? '',
    );
  }
}

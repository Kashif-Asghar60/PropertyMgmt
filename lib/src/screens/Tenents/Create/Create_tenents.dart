import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:propertymgmt_uae/src/screens/DropdownData/dropdownFBservices.dart';
import 'package:propertymgmt_uae/src/widgets/buttonCustom.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/customNormalText.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/customTextField.dart';
import 'package:propertymgmt_uae/src/widgets/customTextforfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Data/model.dart';

class CreateTenants extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const CreateTenants({Key? key, this.initialData}) : super(key: key);

  @override
  _CreateTenantsState createState() => _CreateTenantsState();
}

class _CreateTenantsState extends State<CreateTenants> {
  final List<TextEditingController> controllers = List.generate(
    9,
    (index) => TextEditingController(),
  );

  final List<String?> errors = List.generate(
    9,
    (index) => null, // Initially, no errors
  );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Tenant? tenant; // Use the Tenant model
    
  @override
  void initState() {
    
    super.initState();
    if (widget.initialData != null) {
     // print("iinin data ${widget.initialData}");
      tenant =
          Tenant.fromMap(widget.initialData!); // Initialize the tenant object
      populateControllersFromTenant(); // Populate controllers from tenant object
    }
  }

  // Helper method to populate controllers from the tenant object
  void populateControllersFromTenant() {
    controllers[0].text = tenant?.tenantName ?? '';
    controllers[1].text = tenant?.tenantLicenseNo ?? '';
    controllers[2].text = tenant?.mobileNo ?? '';
    controllers[3].text = tenant?.emiratesId ?? '';
    controllers[4].text = tenant?.nationality ?? '';
    controllers[5].text = tenant?.email ?? '';
    controllers[6].text = tenant?.trnNo ?? '';
    controllers[7].text = tenant?.registrationNo ?? '';
    controllers[8].text = tenant?.address ?? '';
  }

  // ...
      bool _isLoading = false;
  Future<void> _uploadData(BuildContext context) async {
    // Reset errors
    for (int i = 0; i < errors.length; i++) {
      setState(() {
        errors[i] = null;
      });
    }

    // Validate the fields with showStar as true
    for (int i = 0; i < rowDataList.length; i++) {
      final rowData = rowDataList[i];
      final controllerIndex = i * 2;
      final controllerValue = controllers[controllerIndex].text;

      if (rowData.showStarA) {
        final error = validateField(controllerValue);
        if (error != null) {
          setState(() {
            errors[controllerIndex] = error;
          });
          return;
        }
      }

      final controllerIndexB = i * 2 + 1;
      final controllerValueB = controllers[controllerIndexB].text;

      if (rowData.showStarB) {
        final error = validateField(controllerValueB);
        if (error != null) {
          setState(() {
            errors[controllerIndexB] = error;
          });
          return;
        }
      }
    }
    setState(() {
      tenant = Tenant(
        tenantName: controllers[0].text,
        tenantLicenseNo: controllers[1].text,
        mobileNo: controllers[2].text,
        emiratesId: controllers[3].text,
        nationality: controllers[4].text,
        email: controllers[5].text,
        trnNo: controllers[6].text,
        registrationNo: controllers[7].text,
        address: controllers[8].text,
      );
    });

    // Get the current user's ID
    final User? user = _auth.currentUser;
    
    if (user != null) {
      final userId = user.uid;
   /*    print(
          "inside current id ${user.uid} ...${user.displayName}..${user.email}");
 */
      // Create a map of data to upload
      final Map<String, dynamic> tenantData = tenant?.toMap() ?? {};

      if (widget.initialData != null) {
        // If initialData is provided, update the existing document
        final documentId = widget.initialData![
            'Document ID']; // You'll need to set documentId on the Tenant model
        print("init data.. ${documentId}");
        await _firestore
            .collection(FirebaseConstants.users)
            .doc(userId)
            .collection(FirebaseConstants.tenants)
            .doc(documentId)
            .update(tenantData);
             setState(() {
         _isLoading = false;
       });
           Navigator.pop(context);
      } else {
        // If initialData is not provided, create a new document

        // If initialData is not provided, create a new document with a generated tenant ID
    final tenantID = await FirebaseServices().generateTenantID();
        print("empty check ddd $tenantID");
    // Add the generated tenant ID to the tenantData map
    tenantData['Tenant ID'] = tenantID;
    // Save the document to Firestore
    await _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.tenants)
        .doc(tenantID) // Use the generated tenant ID as the document ID
        .set(tenantData);
      /*   await _firestore
                 .collection(FirebaseConstants.users)
            .doc(userId)
            .collection(FirebaseConstants.tenants)
            .add(tenantData); */
      }
       setState(() {
         _isLoading = false;
       });
      // Pop the current form screen
      Navigator.pop(context);

      // Navigate or show success message as needed
    }
  }

  String? validateField(String value) {
    if (value.isEmpty) {
      return 'This field is required.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Dimensions.paddingtenants,
        Dimensions.paddingtenants - 10,
        Dimensions.paddingtenants,
        0,
      ),
      color: AppConstants.content_areaClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tenant Details',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          // Use a loop to create rows with two text fields
          Column(
            children: List.generate(
              rowDataList.length,
              (int index) {
                final rowData = rowDataList[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Dimensions.widthTxtField * 1.6,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: rowData.labelA,
                                fontSize: Dimensions.Txtfontsize,
                                fontWeight: FontWeight.w500,
                                showStar: rowData.showStarA,
                              ),
                              SizedBox(
                                width: Dimensions.spaceBetweenTxtField,
                              ),
                              CustomTextField(
                                width: Dimensions.widthTxtField,
                                backgroundColor: AppConstants.whitecontainer,
                                hintText: rowData.labelA_Hint,
                                controller: controllers[index * 2],
                                errorText: errors[index * 2],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.rowspaceBetweenTxtField,
                        ),
                        SizedBox(
                          width: Dimensions.widthTxtField * 1.65,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: rowData.labelB,
                                fontSize: Dimensions.Txtfontsize,
                                fontWeight: FontWeight.w500,
                                showStar: rowData.showStarB,
                              ),
                              SizedBox(
                                width: Dimensions.spaceBetweenTxtField,
                              ),
                              CustomTextField(
                                width: Dimensions.widthTxtField,
                                backgroundColor: AppConstants.whitecontainer,
                                hintText: rowData.labelb_Hint,
                                controller: controllers[index * 2 + 1],
                                errorText: errors[index * 2 + 1],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.sizeboxWidth * 2),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * 2),
          // Two-line text area for address
          CustomNormalText(
            text: 'Address:',
            fontSize: Dimensions.Txtfontsize,
          ),
          SizedBox(height: Dimensions.sizeboxWidth * 2),
          SizedBox(
            height: Dimensions.buttonHeight * 1.4,
            child: CustomTextField(
              maxLines: 4,
              width: Dimensions.widthTxtField * 5,
              backgroundColor: AppConstants.whitecontainer,
              hintText: "Address",
              controller: controllers[8], // Address controller
              errorText: errors[8],
            ),
          ),
          SizedBox(height: Dimensions.sizeboxWidth * 8),
          // Cancel and Save buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                width: Dimensions.buttonWidth,
                height: Dimensions.buttonHeight,
                color: AppConstants.whitecontainer,
                txtcolor: AppConstants.BlackTxtColor,
                text: "Cancel",
                fontSize: Dimensions.Txtfontsize,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: Dimensions.sizeboxWidth * 4),
              _isLoading ? CircularProgressIndicator():
              CustomButton(
                width: Dimensions.buttonWidth,
                height: Dimensions.buttonHeight,
                color: AppConstants.greenbutton,
                txtcolor: AppConstants.whiteTxtColor,
                text: "Save",
                fontSize: Dimensions.Txtfontsize,
                onPressed: () {
                  setState(() {
                     _isLoading = true;
                  });
                    
                  _uploadData(context);
                }, // Call _uploadData on Save button press
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RowData {
  final String labelA;
  final String labelB;
  final String labelA_Hint;
  final String labelb_Hint;
  final bool showStarA;
  final bool showStarB;

  RowData({
    required this.labelA_Hint,
    required this.labelb_Hint,
    required this.labelA,
    required this.labelB,
    this.showStarA = false,
    this.showStarB = false,
  });
}

// Define your list of data
List<RowData> rowDataList = [
  RowData(
    labelA: "Tenant Name",
    labelA_Hint: "Enter Tenant Name Here",
    showStarA: true,
    labelb_Hint: " Enter Tenant License No",
    labelB: "Tenant License No",
    showStarB: true,
  ),
  RowData(
    labelA: "Mobile No",
    showStarA: true,
    labelA_Hint: "Enter Mobile No ",
    labelb_Hint: " Enter Emirates Id ",
    labelB: "Emirates Id",
    showStarB: true,
  ),
  RowData(
    labelA: "Nationality",
    labelA_Hint: "Enter Nationality ",
    labelb_Hint: " Enter Email",
    labelB: "Email",
  ),
  RowData(
    labelA: "TRN No",
    labelA_Hint: "Enter TRN No",
    labelb_Hint: " Enter Registeration No",
    labelB: "Registered",
  ),
];

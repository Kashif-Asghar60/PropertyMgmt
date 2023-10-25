import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/customTextforfield.dart';

class PartiesCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const PartiesCreateForm({Key? key, this.initialData}) : super(key: key);

  @override
  @override
  State<PartiesCreateForm> createState() => _PartiesCreateFormState();
}

class _PartiesCreateFormState extends State<PartiesCreateForm> {
  final List<TextEditingController> controllers = List.generate(
    3,
    (index) => TextEditingController(),
  );
  final List<String?> errorText = List.generate(
    3,
    (index) => "",
  );
PartyFormData? objData;
   void initState() {
    // TODO: implement initState
    super.initState();
  

     if (widget.initialData != null) {
      print("iininvxv data ${widget.initialData}");
     objData =
          PartyFormData.fromMap(widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  }
  void populateControllers() {
    controllers[0].text = objData?.partyID??"";
    controllers[1].text = objData?.partyName??'';
    controllers[2].text = objData?.partyAddress??'';
  }


void _saveDataToFirebase() {
  // Retrieve data from text controllers and fields
  final partyID = controllers[0].text;
  final partyName = controllers[1].text;
  final partyAddress = controllers[2].text;


/*   // Create components for addressCombined
  final components = [
    if (property.isNotEmpty) 'Property: $property',
    if (length.isNotEmpty) 'Length: $length',
    if (width.isNotEmpty) 'Width: $width',
  ];

  final addressCombined = components.isNotEmpty ? components.join(' ') : '';
 */
  // Perform validation for fields where showStar is true
  if (partyID.isEmpty ||
      partyName.isEmpty ||
      partyAddress.isEmpty 
     ) { // Check for remarks field
    setState(() {
      errorText[0] = partyID.isEmpty ? 'Required field' : null;
       errorText[1]= partyName.isEmpty ? 'Required field' : null;
       errorText[2] = partyAddress.isEmpty ? 'Required field' : null;
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
       errorText[0] = null;
   errorText[1]= null;
      errorText[2] = null;
   
  });

  // Create a UnitFormData object
  final partyFormData = PartyFormData(
    partyID: partyID, 
    partyName: partyName,
     partyAddress: partyAddress);

  // Upload data to Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final userId = user!.uid;
  final firebasePath = FirebaseFirestore.instance.collection(FirebaseConstants.users).doc(userId).collection(FirebaseConstants.masterParty);
  final Map<String, dynamic> unitFormDataMap = partyFormData.toMap();

  if (widget.initialData != null) {
    final documentId = widget.initialData!['Document ID'];
    firebasePath.doc(documentId).update(unitFormDataMap);

    // Clear text field values
    controllers[0].clear();
    controllers[1].clear();
    controllers[2].clear();
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
    controllers[0].clear();
    controllers[1].clear();
    controllers[2].clear();
    Navigator.of(context).pop();


      setState(() {
        // Reset dropdown selections if needed
        // Example:
        // propertySelectedVal = selectPropertyItems.first;
        // unitStatusSelectedVal = unitStatusItems.first;
        // unitTypeSelectedVal = unitTypeItems.first;
      });
    }).catchError((error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
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
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(
      heading: "Party Details ",
      onSave: () {
        _saveDataToFirebase();
      },
      centerContent: List.generate(
        rowDataList.length,
        (int index) {
          final rowData = rowDataList[index];

          return Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Dimensions.widthTxtField * 2.4,
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
                        SizedBox(width: Dimensions.spaceBetweenTxtField),
                        index == 2
                            ? Expanded(
                                child: CustomTextField(
                                  height:Dimensions.buttonHeight*2,
                                  width: Dimensions.widthTxtField * 1.3,
                                  maxLines: 3,
                                  backgroundColor: AppConstants.whitecontainer,
                                  hintText: rowData.labelA_Hint,
                                  controller: controllers[index],
                                ),
                              )
                            : CustomTextField(
                                width: Dimensions.widthTxtField,
                                backgroundColor: AppConstants.whitecontainer,
                                hintText: rowData.labelA_Hint,
                                controller: controllers[index],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
            ],
          );
        },
      ),
    );
  }
}

class PartiesRowData {
  final String labelA;

  final String labelA_Hint;

  final bool showStarA;

  PartiesRowData({
    required this.labelA_Hint,
    required this.labelA,
    this.showStarA = false,
  });
}

// Define your list of data
List<PartiesRowData> rowDataList = [
  PartiesRowData(
    labelA: "Party ID",
    labelA_Hint: "Enter Party ID Here",
    showStarA: true,
  ),
  PartiesRowData(
    labelA: "Party Name",
    showStarA: true,
    labelA_Hint: "Enter Party Name ",
  ),
  PartiesRowData(
    labelA: "Party Address",
    showStarA: true,
    labelA_Hint: "Enter Address ",
  ),
];
 
class PartyFormData{
  static const String partyIDField="PartyID";
    static const String partyNameField="PartyName";
  static const String partyAddressField="PartyAddress";

  final String partyID;
    final String partyName;

  final String partyAddress;

PartyFormData({
required this.partyID,
required this.partyName,
required this.partyAddress
});
Map<String,dynamic> toMap(){
  return{
    partyIDField:partyID,
    partyNameField:partyName,
    partyAddressField:partyAddress
  };
  }
factory PartyFormData.fromMap(Map<String,dynamic> map){
  return PartyFormData(
    partyID:map[partyIDField]??"",
    partyName:map[partyNameField]??"",
    partyAddress:map[partyAddressField]??""
  );
}
}
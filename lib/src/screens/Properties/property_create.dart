import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/DropdownData/dropdownFBservices.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/dropdown.dart';

import '../../constants.dart';
import '../../widgets/CustomTextandFields/customTextField.dart';
import '../../widgets/customTextforfield.dart';
import '../Parties/Parties_Create.dart';

class PropertyCreateForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const PropertyCreateForm({Key? key, this.initialData}) : super(key: key);

  State<PropertyCreateForm> createState() => _PropertyCreateFormState();
}

class _PropertyCreateFormState extends State<PropertyCreateForm> {
  PropertyData? objData;
  // Define controllers for text input fields
//final TextEditingController projectNameController = TextEditingController();
//final TextEditingController municipalityController = TextEditingController();
//final TextEditingController zoneController = TextEditingController();
//final TextEditingController sectorController = TextEditingController();
//final TextEditingController propertyTypeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController propertyNumberController =
      TextEditingController();
  final TextEditingController propertyRegNoController = TextEditingController();
  final TextEditingController propertyNameController = TextEditingController();

  final TextEditingController plotNoController = TextEditingController();

  // Define error text for text input fields
  String? projectNameErrorText;
  String? municipalityErrorText;
  String? zoneErrorText;
  String? sectorErrorText;
  String? streetErrorText;
  String? propertyNumberErrorText;
  String? propertyRegNoErrorText;
  String? propertyNameErrorText;
  String? propertyTypeErrorText;
  String? plotNoErrorText;

  List<String> municipalityItems = [
    'Municipality 1',
    'Municipality 2',
    'Municipality 3',
    'Municipality 4',
  ];

  List<String> zoneItems = [
    'Zone A',
    'Zone B',
    'Zone C',
    'Zone D',
  ];

  List<String> sectorItems = [
    'Sector 1',
    'Sector 2',
    'Sector 3',
    'Sector 4',
  ];

/*   List<String> projectItems = [
    'Project 1',
    'Project 2',
    'Project 3',
    'Project 4',
  ]; */
  List<String> projectTypeItems = [
    'ProjectType 1',
    'ProjectType 2',
    'ProjectType 3',
    'ProjectType 4',
  ];
  List<String>? projectItems; // Initialize as null

  String? municipalitySelectedVal = "";
  String? zoneselectedVal = "";
  String? sectorSelectedVal = "";
  String? projectSelectedVal = "";
  String? projectTypeSelectedVal = "";

  var fetchFuturepartyDD;
  void initState() {
    // TODO: implement initState
    super.initState();
    municipalitySelectedVal = municipalityItems.first;
    zoneselectedVal = zoneItems.first;
    sectorSelectedVal = sectorItems.first;
    //projectSelectedVal = projectItems.first;
    projectTypeSelectedVal = projectTypeItems.first;
    fetchFuturepartyDD = FirebaseServices().fetchProjectPartyItems();
    if (widget.initialData != null) {
      print("iinin data ${widget.initialData}");
      objData = PropertyData.fromMap(
          widget.initialData!); // Initialize the tenant object
      populateControllers(); // Populate controllers from tenant object
    }
  }

  void populateControllers() {
    streetController.text = objData?.street ??
        ""; // Initialize with empty string or set to your desired value
    propertyNumberController.text = objData?.propertyNumber ?? "";
    propertyRegNoController.text = objData?.propertyRegNo ?? "";
    propertyNameController.text = objData?.propertyName ?? "";
    plotNoController.text = objData?.plotNo ?? "";
    municipalitySelectedVal =
        objData?.municipality ?? ""; // Initialize with a default value
    zoneselectedVal = objData?.zone ?? "";
    sectorSelectedVal = objData?.sector ?? "";
    projectSelectedVal = objData?.projectName ?? "";
    projectTypeSelectedVal = objData?.propertyType ?? "";
  }

  void _saveDataToFirebase() {
    // Retrieve data from text controllers and fields
    final projectName = projectSelectedVal ?? '';
    final municipality = municipalitySelectedVal ?? '';
    final zone = zoneselectedVal ?? '';
    final sector = sectorSelectedVal ?? '';
    final street = streetController.text;
    final propertyNumber = propertyNumberController.text;
    final propertyRegNo = propertyRegNoController.text;
    final propertyName = propertyNameController.text;
    final propertyType = projectTypeSelectedVal ?? '';
    final plotNo = plotNoController.text;
    final components = [
      if (municipalitySelectedVal != null &&
          municipalitySelectedVal!.isNotEmpty)
        'Municipality: $municipalitySelectedVal',
      if (zoneselectedVal != null && zoneselectedVal!.isNotEmpty)
        'Zone: $zoneselectedVal',
      if (sectorSelectedVal != null && sectorSelectedVal!.isNotEmpty)
        'Sector: $sectorSelectedVal',
      if (streetController.text.isNotEmpty) 'Street: ${streetController.text}',
    ];

    final addressCombined = components.isNotEmpty ? components.join(' ') : '';

    // Perform validation for fields where showStar is true
    if (projectName.isEmpty ||
        propertyNumber.isEmpty ||
        propertyRegNo.isEmpty ||
        propertyName.isEmpty ||
        propertyType.isEmpty) {
      setState(() {
        projectNameErrorText = projectName.isEmpty ? 'Required field' : null;
        propertyNumberErrorText =
            propertyNumber.isEmpty ? 'Required field' : null;
        propertyRegNoErrorText =
            propertyRegNo.isEmpty ? 'Required field' : null;
        propertyNameErrorText = propertyName.isEmpty ? 'Required field' : null;
        propertyTypeErrorText = propertyType.isEmpty ? 'Required field' : null;
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
      projectNameErrorText = null;
      municipalityErrorText = null;
      zoneErrorText = null;
      sectorErrorText = null;
      streetErrorText = null;
      propertyNumberErrorText = null;
      propertyRegNoErrorText = null;
      propertyNameErrorText = null;
      propertyTypeErrorText = null;
      plotNoErrorText = null;
    });

    // Create a PropertyData object
    final propertyData = PropertyData(
        projectName: projectName,
        municipality: municipality,
        zone: zone,
        sector: sector,
        street: street,
        propertyNumber: propertyNumber,
        propertyRegNo: propertyRegNo,
        propertyName: propertyName,
        propertyType: propertyType,
        plotNo: plotNo,
        addressCombined: addressCombined);

    // Upload data to Firebase
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final userId = user!.uid;
    final firebasePath = FirebaseFirestore.instance
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.rentalProperties);
    final Map<String, dynamic> propertyMap = propertyData.toMap();

    if (widget.initialData != null) {
      final documentId = widget.initialData!['Document ID'];
      firebasePath.doc(documentId).update(propertyMap);
      streetController.clear();
      propertyNumberController.clear();
      propertyRegNoController.clear();
      propertyNameController.clear();
      plotNoController.clear();
      Navigator.of(context).pop();

      // Data updated successfully

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data updated successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      firebasePath.add(propertyMap).then((_) {
        // Data uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data saved successfully."),
            backgroundColor: Colors.green,
          ),
        );
        // Clear text field values
        streetController.clear();
        propertyNumberController.clear();
        propertyRegNoController.clear();
        propertyNameController.clear();
        plotNoController.clear();
        Navigator.of(context).pop();

        setState(() {
          // Reset dropdown selections if needed
          // Example:
          // projectSelectedVal = projectItems.first;
          // municipalitySelectedVal = municipalityItems.first;
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

// Dispose of controllers in the dispose method
  @override
  void dispose() {
/*   projectNameController.dispose();
  municipalityController.dispose();
  zoneController.dispose();
  sectorController.dispose(); */
    streetController.dispose();
    propertyNumberController.dispose();
    propertyRegNoController.dispose();
    propertyNameController.dispose();
    plotNoController.dispose();
    //propertyTypeController.dispose();

    super.dispose();
  }

  double width = 1.67;
  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(
        heading: "Property Details",
        onSave: () {
          _saveDataToFirebase();
        },
        centerContent: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Project Name",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*   CustomTextField(
                  width: Dimensions.widthTxtField,
                  backgroundColor: AppConstants.whitecontainer,
                ), */
                    /*      CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: projectItems ?? [],
                        value: projectSelectedVal,
                        onChanged: (newValue) {
                          if (projectItems?.contains(newValue) == true) {
                            // Check if newValue is a valid item
                            setState(() {
                              projectSelectedVal = newValue;
                            });
                          } else {
                            // Handle the case where newValue is not a valid item
                          }
                         
                        },
                        errorText: projectNameErrorText,
                        backgroundColor: AppConstants.whitecontainer),
                */
                    FutureBuilder<List<String>>(
                      future:
                          fetchFuturepartyDD, // Function to fetch project items
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Loading indicator while fetching data
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text(
                              'No data available'); // Handle case where there is no data
                        } else {
                          // Project items loaded successfully
                          final Items = snapshot.data!;
                          print("\n  $Items\n ");

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
                            errorText: projectNameErrorText,
                            backgroundColor: AppConstants.whitecontainer,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Property Address",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*  CustomTextField(
                  width: Dimensions.widthTxtField,
                  backgroundColor: AppConstants.whitecontainer,
                ) */
                    SizedBox(width: Dimensions.spaceBetweenTxtField * 2),

                    CustomDropdownTextField(
                        width: Dimensions.widthTxtField / 2,
                        label: "Munciplity*",
                        items: municipalityItems,
                        value: municipalitySelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            municipalitySelectedVal = newValue;
                          });
                        },
                        backgroundColor: AppConstants.whitecontainer),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),

                    CustomDropdownTextField(
                        width: Dimensions.widthTxtField / 2,
                        label: "Zone*",
                        items: zoneItems,
                        value: zoneselectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            zoneselectedVal = newValue;
                          });
                        },
                        backgroundColor: AppConstants.whitecontainer),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),

                    CustomDropdownTextField(
                        width: Dimensions.widthTxtField / 2,
                        label: "Sector*",
                        items: sectorItems,
                        value: sectorSelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            sectorSelectedVal = newValue;
                          });
                        },
                        backgroundColor: AppConstants.whitecontainer),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      hintText: "Street",
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: streetController,
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Property Number",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: propertyNumberController,
                      errorText: propertyNumberErrorText,
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Property Reg. No",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: propertyRegNoController,
                      errorText: propertyRegNoErrorText,
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Property Name",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: propertyNameController,
                      errorText: propertyNameErrorText,
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Property Type",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    /*    CustomTextField(
                  width: Dimensions.widthTxtField,
                  backgroundColor: AppConstants.whitecontainer,
                ) */
                    CustomDropdownTextField(
                        width: Dimensions.widthTxtField,
                        label: "",
                        items: projectTypeItems,
                        value: projectTypeSelectedVal,
                        onChanged: (newValue) {
                          setState(() {
                            projectTypeSelectedVal = newValue;
                          });
                        },
                        errorText: propertyTypeErrorText,
                        backgroundColor: AppConstants.whitecontainer),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
              SizedBox(
                width: Dimensions.widthTxtField * width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Plot No.",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                    //   SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: plotNoController,
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimensions.sizeboxWidth * 5),
            ],
          ),
        ]);
  }
}

class PropertyData {
  static const String projectNameField = 'ProjectName';
  static const String municipalityField = 'Municipality';
  static const String zoneField = 'Zone';
  static const String sectorField = 'Sector';
  static const String streetField = 'Street';
  static const String propertyNumberField = 'PropertyNumber';
  static const String propertyRegNoField = 'PropertyRegNo';
  static const String propertyNameField = 'PropertyName';
  static const String propertyTypeField = 'PropertyType';
  static const String plotNoField = 'PlotNo';

  static const String addressCombinedField = 'AddressCombined';

  final String projectName;
  final String municipality;
  final String zone;
  final String sector;
  final String street;
  final String propertyNumber;
  final String propertyRegNo;
  final String propertyName;
  final String propertyType;
  final String plotNo;
  final String addressCombined;

  PropertyData(
      {required this.projectName,
      required this.municipality,
      required this.zone,
      required this.sector,
      required this.street,
      required this.propertyNumber,
      required this.propertyRegNo,
      required this.propertyName,
      required this.propertyType,
      required this.plotNo,
      required this.addressCombined});

  Map<String, dynamic> toMap() {
    return {
      projectNameField: projectName,
      municipalityField: municipality,
      zoneField: zone,
      sectorField: sector,
      streetField: street,
      propertyNumberField: propertyNumber,
      propertyRegNoField: propertyRegNo,
      propertyNameField: propertyName,
      propertyTypeField: propertyType,
      plotNoField: plotNo,
      addressCombinedField: addressCombined
    };
  }

  factory PropertyData.fromMap(Map<String, dynamic> map) {
    return PropertyData(
        projectName: map[projectNameField] ?? '',
        municipality: map[municipalityField] ?? '',
        zone: map[zoneField] ?? '',
        sector: map[sectorField] ?? '',
        street: map[streetField] ?? '',
        propertyNumber: map[propertyNumberField] ?? '',
        propertyRegNo: map[propertyRegNoField] ?? '',
        propertyName: map[propertyNameField] ?? '',
        propertyType: map[propertyTypeField] ?? '',
        plotNo: map[plotNoField] ?? '',
        addressCombined: map[addressCombinedField] ?? '');
  }
}

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Properties/property_create.dart';
import 'package:propertymgmt_uae/src/widgets/showdialog.dart';

import '../../constants.dart';
import '../../widgets/CustomErrorDialogue.dart';
import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';

class PropertyInformationTable extends StatefulWidget {
  const PropertyInformationTable({super.key});

  @override
  State<PropertyInformationTable> createState() =>
      _PropertyInformationTableState();
}

class _PropertyInformationTableState extends State<PropertyInformationTable> {
  double tableTextSize = 14.0;
  List<Map<String, String>> filteredData = [];
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> tableData =
      []; // Initialize with an empty list
  List<bool> selectedRows = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<QuerySnapshot> _streamSubscription;

  @override
  void initState() {
    super.initState();
    filteredData.addAll(tableData);
    selectedRows = List.generate(tableData.length, (index) => false);
    _fetchDataFromFirestore();
  }

  @override
  void dispose() {
    _streamSubscription.cancel(); // Cancel the Firestore stream subscription
    super.dispose();
  }

  // Fetch data from fire store and add to the table Data
  void _fetchDataFromFirestore() {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.rentalProperties);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData =
                  doc.data() as Map<String, dynamic>;
              docData['Document ID'] = doc.id;
              print(" ,,vhev $docData ......$doc");
              return docData;
            })
            .map((data) =>
                data.map((key, value) => MapEntry(key, value.toString())))
            .toList();

        setState(() {
          tableData.clear();
          tableData.addAll(data);
          print("tabl $tableData");
          filteredData = List.from(tableData);
          selectedRows = List.generate(tableData.length, (index) => false);
        });
      }, onError: (error) {
        print('Error fetching data: $error');
      });
    }
  }

  void _deleterow(String docId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.rentalProperties)
          .doc(docId)
          .delete(); // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
      DialogHelper.showErrorDialog(context, "Error: $e");
    }
  }

  Future<void> _showDeleteConfirmationDialog(String Id) async {
    print("inside delete");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: const Text('Are you sure you want to delete this document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the _deleteTenant method to delete the tenant
                _deleterow(Id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editdoc(String docid, BuildContext context) {
    // Implement the edit functionality here
    final selectedRowData = tableData.firstWhere(
      (element) => element["Document ID"] == docid,
      orElse: () => {},
    );
    if (selectedRowData.isNotEmpty) {
      showCustomDialog(
          context,
          PropertyCreateForm(
            initialData: selectedRowData,
          ));
    }
  }

  Future<void> _showEditConfirmationDialog(
      String docId, BuildContext context) async {
    return showDialog(
      context: context, // Use the provided context
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Edit Document'),
          content: const Text('Are you sure you want to edit this Document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the _editTenant method to edit the tenant
                Navigator.of(dialogCtx).pop(true);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    ).then((value) => {
          // print(" vvv$value"),
          if (value == true)
            {
              // display the next dialog with the scaffolds context
              _editdoc(docId, context)
            },
        });
  }

  void _selectAllRows(bool? selected) {
    if (selected != null) {
      setState(() {
        for (int i = 0; i < selectedRows.length; i++) {
          selectedRows[i] = selected;
        }
      });
    }
  }

  bool _areAnyRowsSelected() {
    return selectedRows.any((selected) => selected);
  }

  void _filterTableData(String query) {
    setState(() {
      filteredData = tableData.where((row) {
        final objProperty = PropertyData.fromMap(row);
        print("chking ${objProperty.addressCombined}");
        return objProperty.projectName.contains(query) ||
            //objProperty.municipality.contains(query) ||
            objProperty.addressCombined.contains(query) ||
            objProperty.propertyName.contains(query) ||
            objProperty.propertyNumber.contains(query) ||
            objProperty.propertyRegNo.contains(query) ||
            objProperty.propertyType.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Property Information",
      buttonText: "Create New",
      onButtonTap: () {
        // Handle the "Create New" button tap
        showCustomDialog(context, const PropertyCreateForm());
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      onEditButtonTap: () {
        // Handle the "Edit" button tap
        final selectedTenantIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Check if exactly one tenant is selected for editing
        if (selectedTenantIds.length == 1) {
          // Show the edit confirmation dialog
          _showEditConfirmationDialog(selectedTenantIds[0]!, context);
        } else {
          // Show an error message if multiple tenants are selected
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Edit Document'),
                content:
                    const Text('Please select exactly one Document to edit.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      onDeleteButtonTap: () {
        // Handle the "Delete" button tap
        print('TableData length: ${tableData.length}');
        print('selectedRows length: ${selectedRows.length}');
        // Handle the "Delete" button tap

        final selectedTenantIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Debug prints to check the selectedTenantIds
        print('selectedTenantIds: $selectedTenantIds');

        // Check if at least one tenant is selected for deletion
        if (selectedTenantIds.isNotEmpty) {
          // Show the delete confirmation dialog
          _showDeleteConfirmationDialog(selectedTenantIds[0]!);
        } else {
          // Show an error message if no tenant is selected
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Document'),
                content: const Text(
                    'Please select at least one Document to delete.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      columns: [
        DataColumn2(
          fixedWidth: Dimensions.buttonWidth / 2,
          label: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Checkbox(
              value: _areAnyRowsSelected(),
              onChanged: _selectAllRows,
            ),
          ),
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          label: const Text('Project Name'),
          numeric: false,
          tooltip: 'Project Name',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        const DataColumn2(
          size: ColumnSize.L,
          label: Text('Property Address'),
          tooltip: 'Property Address',
        ),
        const DataColumn2(
          label: Text('Property Number'),
          tooltip: 'Property Number',
        ),
        const DataColumn2(
          label: Text('Property Reg. No'),
          tooltip: 'Property Reg. No',
        ),
        const DataColumn2(
          label: Text('Property Name'),
          tooltip: 'Property Name',
        ),
        const DataColumn2(
          label: Text('Property Type'),
          tooltip: 'Property Type',
        ),
        const DataColumn2(
          label: Text('Plot No.'),
          tooltip: 'Plot No.',
        ),
      ],
      rows: filteredData.asMap().entries.map(
        (entry) {
          String addressCombined =
              entry.value[PropertyData.addressCombinedField] ?? '';
          String projectName = entry.value[PropertyData.projectNameField] ?? '';
          String propertyNumber =
              entry.value[PropertyData.propertyNumberField] ?? '';
          String propertyRegNo =
              entry.value[PropertyData.propertyRegNoField] ?? '';
          String propertyName =
              entry.value[PropertyData.propertyNameField] ?? '';
          String propertyType =
              entry.value[PropertyData.propertyTypeField] ?? '';
          String plotNo = entry.value[PropertyData.plotNoField] ?? '';

          // Calculate the maximum text length among all fields
          int maxTextLength = [
            addressCombined.length,
            projectName.length,
            propertyNumber.length,
            propertyRegNo.length,
            propertyName.length,
            propertyType.length,
            plotNo.length,
          ].reduce((max, length) => max > length ? max : length);

          // Calculate the row height based on the maximum text length
          var dynamicRowHeight =
              maxTextLength > 30 ? 2 * Dimensions.buttonHeight : null;

          return DataRow2(
            specificRowHeight: dynamicRowHeight,
            cells: [
              DataCell(
                Checkbox(
                  value: selectedRows[entry.key],
                  onChanged: (value) {
                    setState(() {
                      selectedRows[entry.key] = value!;
                    });
                  },
                ),
              ),
              customDataCell(
                entry.value[PropertyData.projectNameField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.addressCombinedField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.propertyNumberField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.propertyRegNoField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.propertyNameField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.propertyTypeField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                entry.value[PropertyData.plotNoField]!,
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}

/* final List<Map<String, String>> unitTableData = [
  {
    'Project Name': 'Project 1',
    'Property Address': '123 Main Street',
    'Property Number': '12345',
    'Property Reg. No': 'ABC123',
    'Property Name': 'Unit 1',
    'Property Type': 'Apartment',
    'Plot No.': '2023-01-15',
  },
  {
    'Project Name': 'Project 2',
    'Property Address': '456 Elm Street',
    'Property Number': '54321',
    'Property Reg. No': 'DEF456',
    'Property Name': 'Unit 2',
    'Property Type': 'House',
    'Plot No.': '2023-02-15',
  },
  {
    'Project Name': 'Project 3',
    'Property Address': '789 Oak Street',
    'Property Number': '98765',
    'Property Reg. No': 'GHI789',
    'Property Name': 'Unit 3',
    'Property Type': 'Townhouse',
    'Plot No.': '2023-03-15',
  },
  {
    'Project Name': 'Project 4',
    'Property Address': '1234 Maple Street',
    'Property Number': '43210',
    'Property Reg. No': 'JKL123',
    'Property Name': 'Unit 4',
    'Property Type': 'Condo',
    'Plot No.': '2023-04-15',
  },
  {
    'Project Name': 'Project 5',
    'Property Address': '5678 Pine Street',
    'Property Number': '87654',
    'Property Reg. No': 'MNO567',
    'Property Name': 'Unit 5',
    'Property Type': 'Duplex',
    'Plot No.': '2023-05-15',
  },
  {
    'Project Name': 'Project 6',
    'Property Address': '9012 Spruce Street',
    'Property Number': '21098',
    'Property Reg. No': 'PQR901',
    'Property Name': 'Unit 6',
    'Property Type': 'Triplex',
    'Plot No.': '2023-06-15',
  },
  {
    'Project Name': 'Project 7',
    'Property Address': '12345 Birch Street',
    'Property Number': '54321',
    'Property Reg. No': 'STU123',
    'Property Name': 'Unit 7',
    'Property Type': 'Fourplex',
    'Plot No.': '2023-07-15',
  },
  {
    'Project Name': 'Project 8',
    'Property Address': '56789 Cedar Street',
    'Property Number': '98765',
    'Property Reg. No': 'VWX567',
    'Property Name': 'Unit 8',
    'Property Type': 'Apartment Building',
    'Plot No.': '2023-08-15',
  },
  {
    'Project Name': 'Project 9',
    'Property Address': '123456 Elm Street',
    'Property Number': '43210',
    'Property Reg. No': 'YZA123',
    'Property Name': 'Unit 9',
    'Property Type': 'Office Building',
    'Plot No.': '2023-09-15',
  },
  {
    'Project Name': 'Project 10',
    'Property Address': '789012 Oak Street',
    'Property Number': '87654',
    'Property Reg. No': 'ABC789',
    'Property Name': 'Unit 10',
    'Property Type': 'Retail Building',
    'Plot No.': '2023-10-15',
  },
];
 */
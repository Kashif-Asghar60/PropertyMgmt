import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_create.dart';
import 'package:propertymgmt_uae/src/widgets/showdialog.dart';

import '../../constants.dart';
import '../../widgets/CustomErrorDialogue.dart';
import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';

class UnitInformation extends StatefulWidget {
  const UnitInformation({Key? key}) : super(key: key);

  @override
  State<UnitInformation> createState() => _UnitInformationState();
}

class _UnitInformationState extends State<UnitInformation> {
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
      final collectionReference =
          _firestore.collection(FirebaseConstants.users).doc(userId).collection(FirebaseConstants.rentalUnits);
      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData =
                  doc.data() as Map<String, dynamic>;
              docData['Document ID'] = doc.id;
              //   print(" ,,vhev $docData ......$doc");
              return docData;
            })
            .map((data) =>
                data.map((key, value) => MapEntry(key, value.toString())))
            .toList();

        setState(() {
          tableData.clear();
          tableData.addAll(data);
          //  print("tabl $tableData");
          filteredData = List.from(tableData);
          selectedRows = List.generate(tableData.length, (index) => false);
        });
      }, onError: (error) {
        // print('Error fetching data: $error');
        // Show an error Snackbar to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load rental units. Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _deleterow(String docId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.rentalUnits)
          .doc(docId)
          .delete(); // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
      //  print('Error deleting Record: $e');
      DialogHelper.showErrorDialog(context, "Error: $e");
    }
  }

  Future<void> _showDeleteConfirmationDialog(String Id) async {
    // print("inside delete");
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
          UnitCreateForm(
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
        final objUnitInfo = UnitFormData.fromMap(row);
        return objUnitInfo.premiseNo.contains(query) ||
            objUnitInfo.length.contains(query) ||
            objUnitInfo.width.contains(query) ||
            objUnitInfo.property.contains(query) ||
            objUnitInfo.unitSize.contains(query) ||
            objUnitInfo.unitNo.contains(query) ||
            objUnitInfo.unitStatus.contains(query) ||
            objUnitInfo.unitType.contains(query) ||
            objUnitInfo.unitName.contains(query) ||
            objUnitInfo.rentAmount.contains(query) ||
            objUnitInfo.occupiedNo.contains(query) ||
            objUnitInfo.remarks.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Unit Information",
      buttonText: "Create New",
      onButtonTap: () {
        // Handle the "Create New" button tap
        showCustomDialog(context, const UnitCreateForm());
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      widthforMorecolumns: 1.5,
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
      columns:  [
   DataColumn2(
  fixedWidth: Dimensions.buttonWidth / 2,
  label: Container(
    alignment: Alignment.center,
    child: CheckboxListTile(
      value: _areAnyRowsSelected(),
      onChanged: _selectAllRows,
      controlAffinity: ListTileControlAffinity.leading,
      tileColor: Colors.transparent, // Change to your desired background color
      activeColor: Colors.blue, // Change to your desired active color
      checkColor: Colors.white, // Change to your desired check color
      title: const Text('Select All'), // Change to your desired label text
    ),
  ),
  onSort: (columnIndex, ascending) {
    // Implement sorting logic here
  },
)
,
        const DataColumn2(
          label: Text('Premise no'),
          tooltip: 'Premise no',
        ),
          const DataColumn2(
          label: Text('Length'),
          tooltip: 'Length',
        ),
        const DataColumn2(
          label: Text('Width'),
          tooltip: 'Width',
        ),
         const DataColumn2(
          label: Text('Property'),
          tooltip: 'Property',
        ),
        const DataColumn2(
          label: Text('Unit Size (Sq Ft)'),
          tooltip: 'Unit Size (Sq Ft)',
        ),
        const DataColumn2(
          label: Text('Unit No'),
          tooltip: 'Unit No',
        ),
  const DataColumn2(
          label: Text('Unit Status'),
          tooltip: 'Unit Status',
        ),
        const DataColumn2(
          label: Text('Unit Type'),
          tooltip: 'Unit Type',
        ),
         
          const DataColumn2(
          label: Text('Rent'),
          tooltip: 'Rent',
        ),
        const DataColumn2(
          label: Text('Unit Name'),
          tooltip: 'Unit Name',
        ),
        const DataColumn2(
          label: Text('Occupied no'),
          tooltip: 'Occupied no',
        ),
    
      
        const DataColumn2(
          label: Text('Remarks'),
          tooltip: 'Remarks',
        ),
      ],
    rows: filteredData
          .asMap()
          .entries
          .map(
            (entry) {
              final String premiseNo =
                  entry.value[UnitFormData.premiseNoField]!;
              final String length = entry.value[UnitFormData.lengthField]!;
              final String width = entry.value[UnitFormData.widthField]!;
              final String property =
                  entry.value[UnitFormData.propertyField]!;
              final String unitSize =
                  entry.value[UnitFormData.unitSizeField]!;
              final String unitNo =
                  entry.value[UnitFormData.unitNoField]!;
              final String unitStatus =
                  entry.value[UnitFormData.unitStatusField]!;
              final String unitType =
                  entry.value[UnitFormData.unitTypeField]!;
              final String rentAmount =
                  entry.value[UnitFormData.rentAmountField]!;
              final String unitName =
                  entry.value[UnitFormData.unitNameField]!;
              final String occupiedNo =
                  entry.value[UnitFormData.occupiedNoField]!;
              final String remarks =
                  entry.value[UnitFormData.remarksField]!;

              // Calculate the maximum text length among all fields
              int maxTextLength = [
                premiseNo.length,
                length.length,
                width.length,
                property.length,
                unitSize.length,
                unitNo.length,
                unitStatus.length,
                unitType.length,
                rentAmount.length,
                unitName.length,
                occupiedNo.length,
                remarks.length,
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
                    premiseNo,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    length,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    width,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    property,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    unitSize,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    unitNo,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    unitStatus,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    unitType,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    rentAmount,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    unitName,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    occupiedNo,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize,
                  ),
                  customDataCell(
                    remarks,
                    Dimensions.dataCellWidth * 1.3,
                    Dimensions.Txtfontsize,
                  ),
                ],
              );
            },
          )
          .toList(),

    );
  }
}

/* final List<Map<String, String>> unitTableData = [
  {
    'Premise no': 'P001',
    'Unit no': 'U101',
    'Unit Type': 'Apartment',
    'Select Property': 'Property A',
    'Unit Size (Sq Ft)': '800',
    'Unit Name': 'A101',
    'Occupied no': '2',
    'Length': '10',
    'Width': '8',
    'Unit Size': '800',
    'Unit Status': 'Occupied',
    'Rent': '\$1,000',
    'Remarks': 'Corner unit',
  },
  {
    'Premise no': 'P002',
    'Unit no': 'U102',
    'Unit Type': 'Apartment',
    'Select Property': 'Property A',
    'Unit Size (Sq Ft)': '750',
    'Unit Name': 'A102',
    'Occupied no': '1',
    'Length': '9',
    'Width': '7',
    'Unit Size': '750',
    'Unit Status': 'Vacant',
    'Rent': '\$900',
    'Remarks': 'Balcony',
  },
  // Add more data here as needed
];
 */
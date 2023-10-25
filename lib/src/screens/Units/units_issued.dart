import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Units/units_issued_create.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTable/TableDataCell.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTable/layoutTable.dart';

import '../../constants.dart';
import '../../widgets/showdialog.dart';

class UnitIssued extends StatefulWidget {
  const UnitIssued({Key? key});

  @override
  State<UnitIssued> createState() => _UnitIssuedState();
}

class _UnitIssuedState extends State<UnitIssued> {
  double tableTextSize = 14.0;
  final List<Map<String, String>> tableData = []; // Initialize with an empty list
  List<Map<String, String>> filteredData = [];
  final TextEditingController searchController = TextEditingController();
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

  void _fetchDataFromFirestore() {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference =
          _firestore.collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.unitIssued);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
              docData['Document ID'] = doc.id;
          //    print(" vhev $docData ......$doc");
              return docData;
            })
            .map((data) => data.map((key, value) => MapEntry(key, value.toString())))
            .toList();

        setState(() {
          tableData.clear();
          tableData.addAll(data);
       //   print("tabl $tableData");
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
          .collection(FirebaseConstants.unitIssued)
          .doc(docId)
          .delete();      // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting tenant: $e');
    }
  }
   Future<void> _showDeleteConfirmationDialog(String Id) async {
   // print("inside delete");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Document'),
          content: Text('Are you sure you want to delete this a document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the _deleteTenant method to delete the tenant
                _deleterow(Id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  void _editdoc(String docid , BuildContext context) {
    // Implement the edit functionality here
     final selectedRowData=tableData.firstWhere((element) => element["Document ID"]==docid, orElse:()=>{},);
 if(selectedRowData.isNotEmpty){
   showCustomDialog(
          context,
          UnitsIssuedCreateForm(
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
          title: Text('Edit Document'),
          content: Text('Are you sure you want to edit this Document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the _editTenant method to edit the tenant
                Navigator.of(dialogCtx).pop(true);
              },
              child: Text('Edit'),
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
      final unit = UnitsIssuedData.fromMap(row);
 print( "chking ${unit.partyName}");
      return unit.tenantName.contains(query) ||
          unit.partyName.contains(query) ||
          unit.propertyName.contains(query) ||
          unit.rentAmount.contains(query) ||
          unit.property.contains(query) ||
          unit.advance.contains(query) ||
          unit.unit.contains(query) ||
          unit.receiveAmount.contains(query) ||
          unit.purpose.contains(query) ||
          unit.balanceAmount.contains(query);
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      widthforMorecolumns: 1.5,
      headingText: "Units Issued",
      buttonText: "Create New",
      onButtonTap: () {
        showCustomDialog(context, const UnitsIssuedCreateForm());
      },
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
                title: Text('Edit Document'),
                content: Text('Please select exactly one Document to edit.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
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
                title: Text('Delete Document'),
                content: Text('Please select at least one Document to delete.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      columns: [
        DataColumn2(
          fixedWidth: Dimensions.buttonWidth/2,
          label: Center(
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
          label: Text('Tenant Name'),
          tooltip: 'Tenant Name',
        ),
        DataColumn2(
          label: Text('Party Name'),
          tooltip: 'Party Name',
        ),
        DataColumn2(
          label: Text('Property Name'),
          tooltip: 'Property Name',
        ),
        DataColumn2(
          label: Text('Rent Amount'),
          tooltip: 'Rent Amount',
        ),
        DataColumn2(
          label: Text('Property'),
          tooltip: 'Property',
        ),
        DataColumn2(
          label: Text('Advance'),
          tooltip: 'Advance',
        ),
        DataColumn2(
          label: Text('Unit'),
          tooltip: 'Unit',
        ),
        DataColumn2(
          label: Text('Receive Amount'),
          tooltip: 'Receive Amount',
        ),
        DataColumn2(
          label: Text('Purpose'),
          tooltip: 'Purpose',
        ),
        DataColumn2(
          label: Text('Balance Amount'),
          tooltip: 'Balance Amount',
        ),
      ],
      rows: filteredData
          .asMap()
          .entries
          .map(
            (entry) => DataRow2(
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
                customDataCell(entry.value[UnitsIssuedData.tenantNameField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.partyNameField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.propertyNameField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.rentAmountField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.propertyField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.advanceField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.unitField]!, Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.receiveAmountField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.purposeField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[UnitsIssuedData.balanceAmountField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
              ],
             
            
            ),
          )
          .toList(),
    );
  }
}

// Helper function to show custom dialog











/* 
class UnitIssued extends StatefulWidget {
  const UnitIssued({Key? key});

  @override
  State<UnitIssued> createState() => _UnitIssuedState();
}

class _UnitIssuedState extends State<UnitIssued> {
  double tableTextSize = 14.0;
  final List<Map<String, String>> tableData = [];
  List<Map<String, String>> filteredData = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredData.addAll(tableData);
  }

  void _filterTableData(String query) {
    setState(() {
      filteredData = tableData
          .where((row) =>
              row['Tenant Name']!.contains(query) ||
              row['Party Name']!.contains(query) ||
              row['Property Name']!.contains(query) ||
              row['Rent Amount']!.contains(query) ||
              row['Property']!.contains(query) ||
              row['Advance']!.contains(query) ||
              row['Unit']!.contains(query) ||
              row['Receive Amount']!.contains(query) ||
              row['Purpose']!.contains(query) ||
              row['Balance Amount']!.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      widthforMorecolumns: 1.5,
      headingText: "Units Issued",
      buttonText: "Create New",
      onButtonTap: () {
        showCustomDialog(context, const UnitsIssuedCreateForm());
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      columns: [
        DataColumn2(
          label: Text('Tenant Name'),
          tooltip: 'Tenant Name',
        ),
        DataColumn2(
          label: Text('Party Name'),
          tooltip: 'Party Name',
        ),
        DataColumn2(
          label: Text('Property Name'),
          tooltip: 'Property Name',
        ),
        DataColumn2(
          label: Text('Rent Amount'),
          tooltip: 'Rent Amount',
        ),
        DataColumn2(
          label: Text('Property'),
          tooltip: 'Property',
        ),
        DataColumn2(
          label: Text('Advance'),
          tooltip: 'Advance',
        ),
        DataColumn2(
          label: Text('Unit'),
          tooltip: 'Unit',
        ),
        DataColumn2(
          label: Text('Receive Amount'),
          tooltip: 'Receive Amount',
        ),
        DataColumn2(
          label: Text('Purpose'),
          tooltip: 'Purpose',
        ),
        DataColumn2(
          label: Text('Balance Amount'),
          tooltip: 'Balance Amount',
        ),
      ],
      rows: filteredData
          .asMap()
          .entries
          .map(
            (entry) => DataRow(
              cells: [
                customDataCell(entry.value['Tenant Name']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Party Name']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Property Name']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Rent Amount']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Property']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Advance']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Unit']!, Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(entry.value['Receive Amount']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Purpose']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value['Balance Amount']!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
              ],
            ),
          )
          .toList(),
    );
  }
}

final List<Map<String, String>> tableData = [
  {
    'Tenant Name': 'John Doe',
    'Party Name': 'Party A',
    'Property Name': 'Property 1',
    'Rent Amount': '1000',
    'Property': 'Property A',
    'Advance': '500',
    'Unit': 'Unit 101',
    'Receive Amount': '300',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Alice Johnson',
    'Party Name': 'Party B',
    'Property Name': 'Property 2',
    'Rent Amount': '1200',
    'Property': 'Property B',
    'Advance': '600',
    'Unit': 'Unit 102',
    'Receive Amount': '400',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Bob Smith',
    'Party Name': 'Party C',
    'Property Name': 'Property 3',
    'Rent Amount': '1100',
    'Property': 'Property C',
    'Advance': '550',
    'Unit': 'Unit 103',
    'Receive Amount': '350',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Eve Brown',
    'Party Name': 'Party D',
    'Property Name': 'Property 4',
    'Rent Amount': '1050',
    'Property': 'Property D',
    'Advance': '525',
    'Unit': 'Unit 104',
    'Receive Amount': '325',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Charlie Davis',
    'Party Name': 'Party E',
    'Property Name': 'Property 5',
    'Rent Amount': '950',
    'Property': 'Property E',
    'Advance': '475',
    'Unit': 'Unit 105',
    'Receive Amount': '275',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Grace White',
    'Party Name': 'Party F',
    'Property Name': 'Property 6',
    'Rent Amount': '1150',
    'Property': 'Property F',
    'Advance': '575',
    'Unit': 'Unit 106',
    'Receive Amount': '375',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'David Lee',
    'Party Name': 'Party G',
    'Property Name': 'Property 7',
    'Rent Amount': '1250',
    'Property': 'Property G',
    'Advance': '625',
    'Unit': 'Unit 107',
    'Receive Amount': '425',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Olivia Martin',
    'Party Name': 'Party H',
    'Property Name': 'Property 8',
    'Rent Amount': '1020',
    'Property': 'Property H',
    'Advance': '510',
    'Unit': 'Unit 108',
    'Receive Amount': '320',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'Sophia Hall',
    'Party Name': 'Party I',
    'Property Name': 'Property 9',
    'Rent Amount': '975',
    'Property': 'Property I',
    'Advance': '488',
    'Unit': 'Unit 109',
    'Receive Amount': '295',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
  {
    'Tenant Name': 'William Clark',
    'Party Name': 'Party J',
    'Property Name': 'Property 10',
    'Rent Amount': '1105',
    'Property': 'Property J',
    'Advance': '552',
    'Unit': 'Unit 110',
    'Receive Amount': '352',
    'Purpose': 'Rent',
    'Balance Amount': '200',
  },
];
 */



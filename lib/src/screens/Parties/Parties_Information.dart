import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Parties/Parties_Create.dart';
import 'package:propertymgmt_uae/src/widgets/showdialog.dart';

import '../../constants.dart';
import '../../widgets/CustomErrorDialogue.dart';
import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';
import 'package:data_table_2/data_table_2.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PartyInformationTable extends StatefulWidget {
  const PartyInformationTable({super.key});

  @override
  State<PartyInformationTable> createState() => _PartyInformationTableState();
}

class _PartyInformationTableState extends State<PartyInformationTable> {
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
    _fetchDataFromFirestore();  }

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
          .collection(FirebaseConstants.masterParty);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData =
                  doc.data() as Map<String, dynamic>;
              docData['Document ID'] = doc.id;
              return docData;
            })
            .map((data) =>
                data.map((key, value) => MapEntry(key, value.toString())))
            .toList();

        setState(() {
          tableData.clear();
          tableData.addAll(data);
          filteredData = List.from(tableData);
          selectedRows = List.generate(tableData.length, (index) => false);
        });
      }, onError: (e) {
      DialogHelper.showErrorDialog(context, "Error: $e");
      });
    }
  }

  void _deleterow(String docId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.masterParty)
          .doc(docId)
          .delete(); // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
            DialogHelper.showErrorDialog(context, "Error: $e");

    }
  }

  Future<void> _showDeleteConfirmationDialog(String Id) async {
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
          PartiesCreateForm(
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
        final objParty = PartyFormData.fromMap(row);

        return objParty.partyID.contains(query) ||
            objParty.partyName.contains(query) ||
          
            objParty.partyAddress.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Party Information",
      buttonText: "Create New",
      onButtonTap: () {
        showCustomDialog(context, PartiesCreateForm());
        // Handle the "Create New" button tap
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
      widthforMorecolumns: .7,
      columns: [
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
      title: Text('Select All'), // Change to your desired label text
    ),
  ),
  onSort: (columnIndex, ascending) {
    // Implement sorting logic here
  },
),
        DataColumn2(
         fixedWidth:  Dimensions.widthTxtField / 2,
          label: const Text('Party ID'),
          numeric: false,
          tooltip: 'Party ID',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          fixedWidth: Dimensions.widthTxtField / 1.3 ,
          label: const Text('Party Name'),
          tooltip: 'Party Name',
        ),
        DataColumn2(
          label: SizedBox(
              width: Dimensions.widthTxtField * 1.2,
              child: Text('Party Address')),
          tooltip: 'Party Address',
        ),
      ],
rows: filteredData
    .asMap()
    .entries
    .map(
      (entry) {
        final String partyID = entry.value[PartyFormData.partyIDField]!;
        final String partyName = entry.value[PartyFormData.partyNameField]!;
        final String partyAddress = entry.value[PartyFormData.partyAddressField]!;

        // Calculate the maximum text length among all fields
        int maxTextLength = [
          partyID.length,
          partyName.length,
          partyAddress.length,
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
              partyID,
              Dimensions.dataCellWidth,
              Dimensions.Txtfontsize,
            ),
            customDataCell(
              partyName,
              Dimensions.dataCellWidth,
              Dimensions.Txtfontsize,
            ),
            customDataCell(
              partyAddress,
              Dimensions.dataCellWidth * 2,
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
/* 
final List<Map<String, String>> propertyTableData = [
  {
    'Party ID': '1',
    'Party Name': 'Party A',
    'Party Address': 'Address A ',
  },
  {
    'Party ID': '2',
    'Party Name': 'Party B',
    'Party Address': 'Address B',
  },
  {
    'Party ID': '3',
    'Party Name': 'Party C',
    'Party Address': 'Address C',
  },
  {
    'Party ID': '4',
    'Party Name': 'Party D',
    'Party Address': 'Address D',
  },
  {
    'Party ID': '5',
    'Party Name': 'Party E',
    'Party Address': 'Address E',
  },
  {
    'Party ID': '6',
    'Party Name': 'Party F',
    'Party Address': 'Address F',
  },
  {
    'Party ID': '7',
    'Party Name': 'Party G',
    'Party Address': 'Address G',
  },
  {
    'Party ID': '8',
    'Party Name': 'Party H',
    'Party Address': 'Address H',
  },
  {
    'Party ID': '9',
    'Party Name': 'Party I',
    'Party Address': 'Address I',
  },
  {
    'Party ID': '10',
    'Party Name': 'Party J',
    'Party Address': 'Address J',
  },
   {
    'Party ID': '10',
    'Party Name': 'Party J',
    'Party Address': 'Address J',
  }, {
    'Party ID': '10',
    'Party Name': 'Party J',
    'Party Address': 'Address J',
  }, {
    'Party ID': '10',
    'Party Name': 'Party J',
    'Party Address': 'Address J',
  }, {
    'Party ID': '10',
    'Party Name': 'Party J',
    'Party Address': 'Address J',
  },
];
 */
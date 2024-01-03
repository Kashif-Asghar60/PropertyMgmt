import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Journal%20Voucher/create_journal_voucher.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/customNormalText.dart';

import '../../../constants.dart';
import '../../../widgets/CustomTable/TableDataCell.dart';
import '../../../widgets/CustomTable/layoutTable.dart';
import '../../../widgets/showdialog.dart';

class Details_Journal_voucher extends StatefulWidget {
  const Details_Journal_voucher({super.key});

  @override
  State<Details_Journal_voucher> createState() => _Details_Journal_voucherState();
}

class _Details_Journal_voucherState extends State<Details_Journal_voucher> {
    double tableTextSize = 14.0;
  //final List<Map<String, String>> tableData = []; // Initialize with an empty list
   final List<Map<String, String>> tableData = [
  {
    JournalCreateVoucherModelData.branchField: 'Branch 1',
    JournalCreateVoucherModelData.voucherTypeField: 'Type 1',
    JournalCreateVoucherModelData.voucherNoField: '123',
    JournalCreateVoucherModelData.voucherDateField: '2022-01-01',
    JournalCreateVoucherModelData.acCodeField: 'Code 1',
    JournalCreateVoucherModelData.acHeadField: 'Head 1',
    JournalCreateVoucherModelData.amountFCField: '100',
    JournalCreateVoucherModelData.currencyField: 'USD',
    JournalCreateVoucherModelData.remarksField: 'Remark 1',
  },
  {
    JournalCreateVoucherModelData.branchField: 'Branch 2',
    JournalCreateVoucherModelData.voucherTypeField: 'Type 2Type 2Type 2Type 2Type 2Type 2Type 2Type 2Type 2Type 2Type 2',
    JournalCreateVoucherModelData.voucherNoField: '456',
    JournalCreateVoucherModelData.voucherDateField: '2022-01-02',
    JournalCreateVoucherModelData.acCodeField: 'Code 2',
    JournalCreateVoucherModelData.acHeadField: 'Head 2',
    JournalCreateVoucherModelData.amountFCField: '200',
    JournalCreateVoucherModelData.currencyField: 'EUR',
    JournalCreateVoucherModelData.remarksField: 'Remark 2',
  },
  {
    JournalCreateVoucherModelData.branchField: 'Branch 2',
    JournalCreateVoucherModelData.voucherTypeField: 'Type 2',
    JournalCreateVoucherModelData.voucherNoField: '456',
    JournalCreateVoucherModelData.voucherDateField: '2022-01-02',
    JournalCreateVoucherModelData.acCodeField: 'Code 3',
    JournalCreateVoucherModelData.acHeadField: 'Head 3',
    JournalCreateVoucherModelData.amountFCField: '300',
    JournalCreateVoucherModelData.currencyField: 'GBP',
    JournalCreateVoucherModelData.remarksField: 'Remark 3',
  },
  // Add more data for other entries in your DataColumn2 list
];

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
        .collection(FirebaseConstants.journalVouchers);

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
          JournalCreateVoucher(
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
      final obj = JournalCreateVoucherModelData.fromMap(row);
 print( "chking ${obj.acCode}");
      return obj.acCode.contains(query) ||
          obj.amountFC.contains(query) ||
          obj.balanceAmount.contains(query) ||
          obj.branch.contains(query) ||
          obj.currency.contains(query) ||
          obj.enteredBy.contains(query) ||
          obj.exp.contains(query) ||
          obj.invoiceDate.contains(query) ||
          obj.invoiceNo.contains(query) ||
          obj.mode.contains(query) ||
          obj.remarks.contains(query) ||
          obj.valueDate.contains(query) ||
          obj.voucherDate.contains(query) ||
          obj.voucherType.contains(query) ||
          obj.voucherNo.contains(query)
        ;
    }).toList();
  });
}


  
  @override
  Widget build(BuildContext context) {
    return  CustomDataTableLayout(
      //widthforMorecolumns: 1.5,
      headingText: "Journal Voucher Details",
      buttonText: "Create New",
      onButtonTap: () {
        showCustomDialog(context, const JournalCreateVoucher());
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
          fixedWidth: Dimensions.buttonWidth/1.3,
          label: Checkbox(
            value: _areAnyRowsSelected(),
            onChanged: _selectAllRows,
          ),
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
   label: ReusableAutoSizeText(text: 'Branch'),

  tooltip: 'Branch',
),
DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: 'Voucher Type'),
  tooltip: 'c',
),
DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: 'Voucher No'),
  tooltip: 'Voucher No',
),
DataColumn2(
  label:ReusableAutoSizeText(text: "Voucher Date"),
  tooltip: 'Voucher Date',
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
                customDataCell(entry.value[JournalCreateVoucherModelData.branchField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.voucherTypeField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.voucherNoField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.voucherDateField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
             
              ],
             
            
            ),
          )
          .toList(),
//table 2

showTable2: true,
          columns2: [
        DataColumn2(
          fixedWidth: Dimensions.buttonWidth/1.3,
          label: Checkbox(
            value: _areAnyRowsSelected(),
            onChanged: _selectAllRows,
          ),
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ), 
     DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: "Branch"),
  tooltip: 'Branch',
),
DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: "Account Code"),
  tooltip: 'Account Code',
),
DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: "Account Head"),
  tooltip: 'Account Head',
),
DataColumn2(
  fixedWidth: Dimensions.dataCellWidth / 2,
  label: ReusableAutoSizeText(text: "Amount FC"),
  tooltip: 'Amount FC',
),
DataColumn2(
    fixedWidth: Dimensions.dataCellWidth / 2,

  label: ReusableAutoSizeText(text: "Currency"),
  tooltip: 'Currency',
),
DataColumn2(
  label: ReusableAutoSizeText(text: "Remarks"),

),

    
      ],
          rows2:  filteredData
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
                customDataCell(entry.value[JournalCreateVoucherModelData.branchField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.acCodeField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.acHeadField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[JournalCreateVoucherModelData.amountFCField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                             customDataCell(entry.value[JournalCreateVoucherModelData.currencyField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),          
                          customDataCell(entry.value[JournalCreateVoucherModelData.remarksField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
              ],
             
            
            ),
          )
          .toList(),

    );
  
  }
}
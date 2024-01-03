import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Currency%20Recipts/create_currencyRecipt.dart';
import 'package:propertymgmt_uae/src/screens/Reports/Journal%20Voucher/create_journal_voucher.dart';
import 'package:propertymgmt_uae/src/widgets/CustomTextandFields/customNormalText.dart';

import '../../../constants.dart';
import '../../../widgets/CustomTable/TableDataCell.dart';
import '../../../widgets/CustomTable/layoutTable.dart';
import '../../../widgets/showdialog.dart';

class Details_Currency_Reciept extends StatefulWidget {
  const Details_Currency_Reciept({super.key});

  @override
  State<Details_Currency_Reciept> createState() =>
      _Details_Currency_RecieptState();
}

class _Details_Currency_RecieptState extends State<Details_Currency_Reciept> {
  double tableTextSize = 14.0;
/*   final List<Map<String, String>> tableData =
      []; // Initialize with an empty list
 */
final List<Map<String, String>> tableData = [
  {
    CreateCurrencyReceiptData.voucherTypeField: 'Type 1',
    CreateCurrencyReceiptData.voucherTypeNoField: '123',
    CreateCurrencyReceiptData.enteredByField: 'User 1',
    CreateCurrencyReceiptData.voucherDateField: '2022-01-01',
    CreateCurrencyReceiptData.posCustomerField: 'Customer 1',
    CreateCurrencyReceiptData.partyCodeField: 'Code 1',
    CreateCurrencyReceiptData.partyCode1Field: 'Code 1.1',
    CreateCurrencyReceiptData.partyCode2Field: 'Code 1.2',
    CreateCurrencyReceiptData.partyCurrencyField: 'USD',
    CreateCurrencyReceiptData.partyCurrencyAmountField: '500',
    CreateCurrencyReceiptData.referenceNumberField: 'Ref 1',
    CreateCurrencyReceiptData.referenceDateField: '2022-01-02',
    CreateCurrencyReceiptData.tnNoField: 'TN123',
    CreateCurrencyReceiptData.modeField: 'Mode 1',
    CreateCurrencyReceiptData.branchField: 'Branch 1',
    CreateCurrencyReceiptData.acHeadField: 'Head 1',
    CreateCurrencyReceiptData.expField: 'Expense 1',
    CreateCurrencyReceiptData.valueDateField: '2022-01-03',
    CreateCurrencyReceiptData.cashInHandField: 'Cash 1',
    CreateCurrencyReceiptData.currencyCodeField: 'USD',
    CreateCurrencyReceiptData.amountFCField: '1000',
    CreateCurrencyReceiptData.headAmountField: '2000',
    CreateCurrencyReceiptData.remarksField: 'Remark 1',
  },
  {
    CreateCurrencyReceiptData.voucherTypeField: 'Type 2',
    CreateCurrencyReceiptData.voucherTypeNoField: '456',
    CreateCurrencyReceiptData.enteredByField: 'User 2',
    CreateCurrencyReceiptData.voucherDateField: '2022-02-01',
    CreateCurrencyReceiptData.posCustomerField: 'Customer 2',
    CreateCurrencyReceiptData.partyCodeField: 'Code 2',
    CreateCurrencyReceiptData.partyCode1Field: 'Code 2.1',
    CreateCurrencyReceiptData.partyCode2Field: 'Code 2.2',
    CreateCurrencyReceiptData.partyCurrencyField: 'EUR',
    CreateCurrencyReceiptData.partyCurrencyAmountField: '700',
    CreateCurrencyReceiptData.referenceNumberField: 'Ref 2',
    CreateCurrencyReceiptData.referenceDateField: '2022-02-02',
    CreateCurrencyReceiptData.tnNoField: 'TN456',
    CreateCurrencyReceiptData.modeField: 'Mode 2',
    CreateCurrencyReceiptData.branchField: 'Branch 2',
    CreateCurrencyReceiptData.acHeadField: 'Head 2',
    CreateCurrencyReceiptData.expField: 'Expense 2',
    CreateCurrencyReceiptData.valueDateField: '2022-02-03',
    CreateCurrencyReceiptData.cashInHandField: 'Cash 2',
    CreateCurrencyReceiptData.currencyCodeField: 'EUR',
    CreateCurrencyReceiptData.amountFCField: '1500',
    CreateCurrencyReceiptData.headAmountField: '2500',
    CreateCurrencyReceiptData.remarksField: 'Remark 2',
  },
  // Add more data entries as needed
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
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.journalVouchers);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData =
                  doc.data() as Map<String, dynamic>;
              docData['Document ID'] = doc.id;
              //    print(" vhev $docData ......$doc");
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
          .delete(); // Update the UI by refetching the data
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

  void _editdoc(String docid, BuildContext context) {
    // Implement the edit functionality here
    final selectedRowData = tableData.firstWhere(
      (element) => element["Document ID"] == docid,
      orElse: () => {},
    );
    if (selectedRowData.isNotEmpty) {
      showCustomDialog(
          context,
          Create_CurrencyReciept(
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
        final obj = CreateCurrencyReceiptData.fromMap(row);
        return obj.acHead.contains(query) ||
            obj.amountFC.contains(query) ||
            obj.branch.contains(query) ||
            obj.cashInHand.contains(query) ||
            obj.currencyCode.contains(query) ||
            obj.enteredBy.contains(query) ||
            obj.exp.contains(query) ||
            obj.headAmount.contains(query) ||
            obj.mode.contains(query) ||
            obj.remarks.contains(query) ||
            obj.valueDate.contains(query) ||
            obj.voucherDate.contains(query) ||
            obj.voucherType.contains(query) ||
            obj.voucherTypeNo.contains(query) ||
            obj.posCustomer.contains(query) ||
            obj.partyCode.contains(query) ||
            obj.partyCode1.contains(query) ||
            obj.partyCode2.contains(query) ||
            obj.partyCurrency.contains(query) ||
            obj.partyCurrencyAmount.contains(query) ||
            obj.referenceNumber.contains(query) ||
            obj.referenceDate.contains(query) ||
            obj.tnNo.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Currency Reciept",
      buttonText: "Create New",
      onButtonTap: () {
        showCustomDialog(context, const Create_CurrencyReciept());
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
          fixedWidth: Dimensions.buttonWidth / 1.3,
          label: Checkbox(
            value: _areAnyRowsSelected(),
            onChanged: _selectAllRows,
          ),
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Voucher Type'),
          tooltip: 'c',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Voucher No'),
          tooltip: 'Voucher No',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: "Voucher Date"),
          tooltip: 'Voucher Date',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Entered By'),
          tooltip: 'Entered By',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'POS Customer'),
          tooltip: 'POS Customer',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Party Code'),
          tooltip: 'Party',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Party Currency'),
          tooltip: 'Party Currency',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Reference #'),
          tooltip: 'Reference',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'Reference Date'),
          tooltip: 'Reference',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: 'TRN No'),
          tooltip: 'TRN NO',
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
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.voucherTypeField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.voucherTypeNoField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.voucherDateField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.enteredByField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.posCustomerField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.partyCodeField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                     customDataCell(
                    entry.value[CreateCurrencyReceiptData.partyCurrencyField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry
                        .value[CreateCurrencyReceiptData.referenceNumberField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.referenceDateField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.tnNoField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
              ],
            ),
          )
          .toList(),

//table 2

      showTable2: true,
      columns2: [
        DataColumn2(
          fixedWidth: Dimensions.buttonWidth / 1.3,
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
          label: ReusableAutoSizeText(text: "Mode"),
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Account Head"),
          tooltip: 'Account Head',
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Cash"),
          tooltip: 'Cash in hand',
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Exp"),
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Currency Code"),
          tooltip: 'Currency Code',
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Header Amt"),
          tooltip: 'Header Amt',
        ),
        DataColumn2(
          fixedWidth: Dimensions.dataCellWidth / 2,
          label: ReusableAutoSizeText(text: "Amount FC"),
          tooltip: 'Amount FC',
        ),
        DataColumn2(
          label: ReusableAutoSizeText(text: "Remarks"),
        ),
      ],
      rows2: filteredData
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
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.branchField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.modeField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.acHeadField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.cashInHandField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(entry.value[CreateCurrencyReceiptData.expField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.currencyCodeField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.headAmountField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.amountFCField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[CreateCurrencyReceiptData.remarksField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
              ],
            ),
          )
          .toList(),
    );
  }
}

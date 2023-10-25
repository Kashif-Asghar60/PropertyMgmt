import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:propertymgmt_uae/src/screens/Payment/printReceipts/payment_cheque.dart';
import 'package:propertymgmt_uae/src/widgets/CustomErrorDialogue.dart';

import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';
import '../../widgets/showdialog.dart';
import 'payment_create.dart';

class PaymentInformation extends StatefulWidget {
  const PaymentInformation({Key? key}) : super(key: key);

  @override
  State<PaymentInformation> createState() => _PaymentInformationState();
}

class _PaymentInformationState extends State<PaymentInformation> {
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

  // Fetch data from Firestore and update state when new data is added or updated
  void _fetchDataFromFirestore() {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.payments);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData = doc.data();
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
      }, onError: (error) {
        print('Error fetching data: $error');
        DialogHelper.showErrorDialog(context, error.toString());
      });
    }
  }

  void _deleteRow(String docId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.payments)
          .doc(docId)
          .delete(); // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting Record: $e');
      DialogHelper.showErrorDialog(context, e.toString());
    }
  }

  Future<void> _showDeleteConfirmationDialog(String id) async {
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
                // Call the _deleteRow method to delete the row
                _deleteRow(id);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editRow(String docId, BuildContext context) {
    final selectedRowData = tableData.firstWhere(
      (element) => element["Document ID"] == docId,
      orElse: () => {},
    );
    if (selectedRowData.isNotEmpty) {
      // Show the edit dialog with the selected row data
      showCustomDialog(
        context,
        PaymentCreateForm(initialData: selectedRowData),
      );
    }
  }

  Future<void> _showEditConfirmationDialog(
      String docId, BuildContext context) async {
    return showDialog(
      context: context,
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
                // Call the _editRow method to edit the row
                Navigator.of(dialogCtx).pop(true);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        // Display the next dialog with the scaffold's context
        _editRow(docId, context);
      }
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
        final paymentData = PaymentCreateData.fromMap(row);
        return paymentData.collectionNo?.contains(query) == true ||
            paymentData.unitName?.contains(query) == true ||
            paymentData.bankName?.contains(query) == true ||
            paymentData.paymentMethodSelectedVal?.contains(query) == true ||
            paymentData.tenantSelectedVal?.contains(query) == true ||
            
            paymentData.projectSelectedVal?.contains(query) == true ||
            paymentData.collectionDate?.contains(query) == true ||
            paymentData.chequeDate?.contains(query) == true ||
            paymentData.chequeNo?.contains(query) == true ||

            paymentData.preBalance?.contains(query) == true ||
            paymentData.discount?.contains(query) == true ||
            paymentData.paidAmount?.contains(query) == true ||
            paymentData.balance?.contains(query) == true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Payment Information",
      buttonText: "Create New",
      onButtonTap: () {
        // Handle the "Create New" button tap
       showCustomDialog(context, const PaymentCreateForm());
      
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      widthforMorecolumns: 1.5,
      onEditButtonTap: () {
        // Handle the "Edit" button tap
        final selectedIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Check if exactly one item is selected for editing
        if (selectedIds.length == 1) {
          // Show the edit confirmation dialog
          _showEditConfirmationDialog(selectedIds[0]!, context);
        } else {
          // Show an error message if multiple items are selected
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
        final selectedIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Check if at least one item is selected for deletion
        if (selectedIds.isNotEmpty) {
          // Show the delete confirmation dialog
          _showDeleteConfirmationDialog(selectedIds[0]!);
        } else {
          // Show an error message if no items are selected
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
          label: const Text('Collection No'),
          numeric: false,
          tooltip: 'Collection No',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
          const DataColumn2(
          label: Text('Collection Date'),
          tooltip: 'Collection Date',
        ),
            const DataColumn2(
          label: Text('Payment Method'),
          tooltip: 'Payment Method',
        ),
            const DataColumn2(
          label: Text('Tenant Name'),
          tooltip: 'Tenant Name',
        ),
            const DataColumn2(
          label: Text('Cheque Date'),
          tooltip: 'Cheque Date',
        ),  
        const DataColumn2(
          label: Text('Project Name'),
          tooltip: 'Project Name',
        ),
           const DataColumn2(
          label: Text('Cheque No'),
          tooltip: 'Cheque No',
        ),
        const DataColumn2(
          label: Text('Unit Name'),
          tooltip: 'Unit Name',
        ),
        const DataColumn2(
          label: Text('Bank Name'),
          tooltip: 'Bank Name',
        ),
    
     
     
        const DataColumn2(
          label: Text('Pre Balance'),
          tooltip: 'Pre Balance',
        ),
        const DataColumn2(
          label: Text('Discount'),
          tooltip: 'Discount',
        ),
        const DataColumn2(
          label: Text('Paid Amount'),
          tooltip: 'Paid Amount',
        ),
        const DataColumn2(
          label: Text('Balance'),
          tooltip: 'Balance',
        ),
      ],
      rows: filteredData.asMap().entries.map(
        (entry) {
          PaymentCreateData paymentData =
              PaymentCreateData.fromMap(entry.value);

          // Calculate the maximum text length among all fields in PaymentCreateData
          int maxTextLength = [
            paymentData.collectionNo?.length ?? 0,
            paymentData.collectionDate?.length ?? 0,
            paymentData.paymentMethodSelectedVal?.length ?? 0,
            paymentData.tenantSelectedVal?.length ?? 0,

            paymentData.chequeDate?.length ?? 0,

            paymentData.projectSelectedVal?.length ?? 0,
            paymentData.chequeNo?.length ?? 0,
            paymentData.unitName?.length ?? 0,
            paymentData.bankName?.length ?? 0,

            paymentData.preBalance?.length ?? 0,
            paymentData.discount?.length ?? 0,
            paymentData.paidAmount?.length ?? 0,
            paymentData.balance?.length ?? 0,
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
                paymentData.collectionNo ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
               customDataCell(
                paymentData.collectionDate ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
               customDataCell(
                paymentData.paymentMethodSelectedVal ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
               customDataCell(
                paymentData.tenantSelectedVal ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
                customDataCell(
                paymentData.chequeDate ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.projectSelectedVal ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.chequeNo ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),

              customDataCell(
                paymentData.unitName ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.bankName ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
             
             
            
              
              customDataCell(
                paymentData.preBalance ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.discount ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.paidAmount ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
              customDataCell(
                paymentData.balance ?? '',
                Dimensions.dataCellWidth,
                Dimensions.Txtfontsize,
              ),
            ],
          );
        },
      ).toList(),
      showPrintChequeButton: true,

      onPrintChequeTap: () {
           final selectedIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Check if exactly one item is selected for editing
        if (selectedIds.length == 1) {
             final selectedRowData = tableData.firstWhere(
      (element) => element["Document ID"] == selectedIds[0]!,
      orElse: () => {},
    );
    if (selectedRowData.isNotEmpty) {
      // Show the edit dialog with the selected row data
      showCustomDialog(
        context,
         PaymentCheque(initialData: selectedRowData ,)
      
      );
    }
        } else {
          // Show an error message if multiple items are selected
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Print'),
                content:
                    const Text('Please select exactly one Document to Print.'),
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
            showPrintReceiptButton: true,
      onPrintReceiptTap:  () {
           final selectedIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => tableData[entry.key]['Document ID'])
            .toList();

        // Check if exactly one item is selected for editing
        if (selectedIds.length == 1) {
             final selectedRowData = tableData.firstWhere(
      (element) => element["Document ID"] == selectedIds[0]!,
      orElse: () => {},
    );
    if (selectedRowData.isNotEmpty) {
      // Show the edit dialog with the selected row data
      showCustomDialog(
        context,
         TenantHistoryMain(initialData: selectedRowData ,)
      
      );
    }
        } else {
          // Show an error message if multiple items are selected
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Print'),
                content:
                    const Text('Please select exactly one Document to Print.'),
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

       
     
      }
    );
  }
}

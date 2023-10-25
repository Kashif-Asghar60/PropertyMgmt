import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Contracts/contract_form.dart';
import 'package:propertymgmt_uae/src/widgets/showdialog.dart';

import '../../constants.dart';
import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';

class ContractInformation extends StatefulWidget {
  const ContractInformation({super.key});

  @override
  State<ContractInformation> createState() => _ContractInformationState();
}

class _ContractInformationState extends State<ContractInformation> {
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

  // Fetch data from firestore and update state when new data is added or updated in realtime database
  void _fetchDataFromFirestore() {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference =
          _firestore.collection(FirebaseConstants.users).doc(userId).collection(FirebaseConstants.contracts);

      _streamSubscription = collectionReference.snapshots().listen((snapshot) {
        final List<Map<String, String>> data = snapshot.docs
            .map((doc) {
              final Map<String, dynamic> docData =
                  doc.data();
              docData['Document ID'] = doc.id;
             // print(" ,,vhev $docData ......$doc");
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
        print('Error fetching data: $error');
      });
    }
  }

  void _deleterow(String docId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.contracts)
          .doc(docId)
          .delete(); // Update the UI by refetching the data
      _fetchDataFromFirestore();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting Record: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(String Id) async {
    print("inside delete");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Document'),
          content: Text('Are you sure you want to delete this document?'),
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
          ContractCreateForm(
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
        final contract = ContractData.fromMap(row);
        print("chking ${contract.annualRent}");
        return contract.contractNo.contains(query) ||
            contract.contractDuration.contains(query) ||
            contract.contractType.contains(query) ||
            contract.annualRent.contains(query) ||
            contract.contractValue.contains(query) ||
            contract.issueDate.contains(query) ||
            contract.endDate.contains(query) ||
            contract.gracePeriod.contains(query) ||
            contract.paymentMethod.contains(query) ||
            contract.paymentPeriod.contains(query) ||
            contract.securityDeposit.contains(query) ||
            contract.servicesAllowed.contains(query) ||
            contract.waterElectricBill.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Contract Information",
      buttonText: "Create New",
      onButtonTap: () {
        // Handle the "Create New" button tap

        showCustomDialog(context, const ContractCreateForm());
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
          label: Text('Contract No'),
          numeric: false,
          tooltip: 'Contract No',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          label: Text('Contract Type'),
          tooltip: 'Contract Type',
        ),
        DataColumn2(
          label: Text('Issue Date'),
          tooltip: 'Issue Date',
        ),
        DataColumn2(
          label: Text('End Date'),
          tooltip: 'End Date',
        ),
        DataColumn2(
          label: Text('Contract Value'),
          tooltip: 'Contract Value',
        ),
        DataColumn2(
          label: Text('Annual Rent'),
          tooltip: 'Annual Rent',
        ),
        DataColumn2(
          label: Text('Payment Period'),
          tooltip: 'Payment Period',
        ),
        DataColumn2(
          label: Text('Security Deposit'),
          tooltip: 'Security Deposit',
        ),
        DataColumn2(
          label: Text('Contract Duration'),
          tooltip: 'Contract Duration',
        ),
        DataColumn2(
          label: Text('Grace Period'),
          tooltip: 'Grace Period',
        ),
        DataColumn2(
          label: Text('Payment Method'),
          tooltip: 'Payment Method',
        ),
        DataColumn2(
          label: Text('Services Allowed'),
          tooltip: 'Services Allowed',
        ),
        DataColumn2(
          label: Text('Water/Electricity Bill'),
          tooltip: 'Water/Electricity Bill',
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
                customDataCell(entry.value[ContractData.contractNoField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.contractTypeField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.issueDateField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.endDateField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.contractValueField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.annualRentField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.paymentPeriodField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.securityDepositField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.contractDurationField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.gracePeriodField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.paymentMethodField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(entry.value[ContractData.servicesAllowedField]!,
                    Dimensions.dataCellWidth, Dimensions.Txtfontsize),
                customDataCell(
                    entry.value[ContractData.waterElectricBillField]!,
                    Dimensions.dataCellWidth,
                    Dimensions.Txtfontsize),
              ],
            ),
          )
          .toList(),
    );
  }
}

/* final List<Map<String, String>> contractTableData = [
  {
    'Contract No': 'CON001',
    'Contract Type': 'Lease',
    'Issue Date': '2023-01-05',
    'End Date': '2024-01-05',
    'Contract Value': '\$10,000',
    'Annual Rent': '\$8,000',
    'Payment Period': 'Monthly',
    'Security Deposit': '\$2,000',
    'Contract Duration': '12 Months',
    'Grace Period': '15 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Electricity, Water',
    'Water/Electricity Bill': '\$100',
  },
  {
    'Contract No': 'CON002',
    'Contract Type': 'Rental',
    'Issue Date': '2023-02-10',
    'End Date': '2024-02-10',
    'Contract Value': '\$12,000',
    'Annual Rent': '\$10,000',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,500',
    'Contract Duration': '18 Months',
    'Grace Period': '30 Days',
    'Payment Method': 'Check',
    'Services Allowed': 'Internet',
    'Water/Electricity Bill': '\$90',
  },
  {
    'Contract No': 'CON003',
    'Contract Type': 'Lease',
    'Issue Date': '2023-03-15',
    'End Date': '2024-03-15',
    'Contract Value': '\$9,500',
    'Annual Rent': '\$7,800',
    'Payment Period': 'Monthly',
    'Security Deposit': '\$1,900',
    'Contract Duration': '14 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Cash',
    'Services Allowed': 'Gas',
    'Water/Electricity Bill': '\$110',
  },
  {
    'Contract No': 'CON004',
    'Contract Type': 'Rental',
    'Issue Date': '2023-04-20',
    'End Date': '2024-04-20',
    'Contract Value': '\$11,500',
    'Annual Rent': '\$9,500',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,200',
    'Contract Duration': '24 Months',
    'Grace Period': '20 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Cable TV',
    'Water/Electricity Bill': '\$85',
  },
  {
    'Contract No': 'CON005',
    'Contract Type': 'Lease',
    'Issue Date': '2023-05-25',
    'End Date': '2024-05-25',
    'Contract Value': '\$8,800',
    'Annual Rent': '\$7,200',
    'Payment Period': 'Monthly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '10 Months',
    'Grace Period': '5 Days',
    'Payment Method': 'Cash',
    'Services Allowed': 'Water',
    'Water/Electricity Bill': '\$120',
  },
  {
    'Contract No': 'CON006',
    'Contract Type': 'Rental',
    'Issue Date': '2023-06-30',
    'End Date': '2024-06-30',
    'Contract Value': '\$13,200',
    'Annual Rent': '\$11,000',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,800',
    'Contract Duration': '20 Months',
    'Grace Period': '25 Days',
    'Payment Method': 'Check',
    'Services Allowed': 'Electricity, Gas',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON007',
    'Contract Type': 'Lease',
    'Issue Date': '2023-07-05',
    'End Date': '2024-07-05',
    'Contract Value': '\$10,500',
    'Annual Rent': '\$8,700',
    'Payment Period': 'Monthly',
    'Security Deposit': '\$2,100',
    'Contract Duration': '16 Months',
    'Grace Period': '12 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV',
    'Water/Electricity Bill': '\$105',
  },
  {
    'Contract No': 'CON008',
    'Contract Type': 'Rental',
    'Issue Date': '2023-08-10',
    'End Date': '2024-08-10',
    'Contract Value': '\$12,800',
    'Annual Rent': '\$10,500',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,600',
    'Contract Duration': '22 Months',
    'Grace Period': '18 Days',
    'Payment Method': 'Cash',
    'Services Allowed': 'Water, Gas',
    'Water/Electricity Bill': '\$80',
  },
  {
    'Contract No': 'CON009',
    'Contract Type': 'Lease',
    'Issue Date': '2023-09-15',
    'End Date': '2024-09-15',
    'Contract Value': '\$9,200',
    'Annual Rent': '\$7,600',
    'Payment Period': 'Monthly',
    'Security Deposit': '\$2,400',
    'Contract Duration': '18 Months',
    'Grace Period': '8 Days',
    'Payment Method': 'Check',
    'Services Allowed': 'Electricity',
    'Water/Electricity Bill': '\$115',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
  {
    'Contract No': 'CON010',
    'Contract Type': 'Rental',
    'Issue Date': '2023-10-20',
    'End Date': '2024-10-20',
    'Contract Value': '\$11,000',
    'Annual Rent': '\$9,200',
    'Payment Period': 'Quarterly',
    'Security Deposit': '\$2,300',
    'Contract Duration': '12 Months',
    'Grace Period': '10 Days',
    'Payment Method': 'Bank Transfer',
    'Services Allowed': 'Internet, Cable TV, Water',
    'Water/Electricity Bill': '\$95',
  },
];
 */
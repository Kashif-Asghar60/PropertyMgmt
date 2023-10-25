import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/screens/Payment/payment_create.dart';
import 'package:propertymgmt_uae/src/screens/Properties/property_create.dart';
import 'package:propertymgmt_uae/src/screens/Tenents/Create/Create_tenents.dart';
import 'package:propertymgmt_uae/src/widgets/showdialog.dart';
import '../../constants.dart';
import '../../widgets/CustomTable/TableDataCell.dart';
import '../../widgets/CustomTable/layoutTable.dart';
import 'Data/tenents_data.dart';

class TenantsInformationTable extends StatefulWidget {
  const TenantsInformationTable({Key? key}) : super(key: key);

  @override
  _TenantsInformationTableState createState() =>
      _TenantsInformationTableState();
}

class _TenantsInformationTableState extends State<TenantsInformationTable> {
  double tableTextSize = 14.0;
  List<Map<String, String>> filteredData = [];
  final TextEditingController searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> propertyTableData = [];
    List<Map<String, String>> propertyTableData2 = [];

  List<bool> selectedRows = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore2();
  }

  final TenantData tenantData = TenantData();
  Stream<QuerySnapshot> _listenToTenantData() {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference =
          _firestore.collection(FirebaseConstants.users).doc(userId).collection(FirebaseConstants.tenants);

      // Return a stream of query snapshots for the collection
      return collectionReference.snapshots();
    }

    // Return an empty stream if the user is not authenticated
    return Stream<QuerySnapshot>.empty();
  }

void _fetchDataFromFirestore2() {
  _listenToTenantData().listen((QuerySnapshot snapshot) {
    final List<Map<String, String>> propertyTableData = snapshot.docs
        .where((doc) => doc.id != 'latestTenantID') // Filter out the second document
        .map((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['Document ID'] = doc.id; // Add the document ID to the map
          return data;
        })
        .map((data) =>
            data.map((key, value) => MapEntry(key, value.toString()))
        )
        .toList();

    setState(() {
      this.propertyTableData = propertyTableData;
      propertyTableData2 = this.propertyTableData;
      print("data: $propertyTableData");
      selectedRows = List.generate(propertyTableData.length, (index) => false);
      filteredData = List.from(propertyTableData);
    });
  }, onError: (error) {
    print('Error fetching data: $error');
  });
}


  void _filterTableData(String query) {
    print("filter r3 ${propertyTableData2
          .where((row) =>
              row['Tenant Name']!.contains(query))} //");

    setState(() {
      filteredData = propertyTableData
          .where((row) =>
                   row['Tenant ID']!.contains(query) ||
              row['Tenant Name']!.contains(query) ||
              row['Trade License no']!.contains(query) ||
              row['Mobile No']!.contains(query) ||
              row['Emirates ID']!.contains(query) ||
              row['Nationality']!.contains(query) ||
              row['Email']!.contains(query) ||
              row['TRN No']!.contains(query) ||
              row['Registered']!.contains(query) ||
             
              row['Address']!.contains(query))
          .toList();
    });
  }

  void _deleteTenant(String tenantId) async {
    // Implement the delete functionality here
    // You can use the tenantId to delete the tenant data from Firestore
    try {
      await tenantData.deleteTenant(tenantId);
      // Update the UI by refetching the data
      _fetchDataFromFirestore2();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting tenant: $e');
    }
  }

  // Define a function to show a confirmation dialog for delete operation
  Future<void> _showDeleteConfirmationDialog(String tenantId) async {
    print("inside delete");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Tenant'),
          content: Text('Are you sure you want to delete this tenant?'),
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
                _deleteTenant(tenantId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditConfirmationDialog(
      String tenantId, BuildContext context) async {
    return showDialog(
      context: context, // Use the provided context
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('Edit Tenant'),
          content: Text('Are you sure you want to edit this tenant?'),
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
          print(" vvv$value"),
          if (value == true)
            {
              // display the next dialog with the scaffolds context
              _editTenant(tenantId, context)
            },
        });
  }

  void _editTenant(String tenantId, BuildContext context) {
    // Find the tenant data for the selected tenantId
    final selectedTenantData = propertyTableData.firstWhere(
      (tenant) => tenant['Document ID'] == tenantId,
      orElse: () => {},
    );

    if (selectedTenantData != null) {
      // Navigate to the CreateTenants page for editing
      //    print("cdcv $selectedTenantData");
      showCustomDialog(
          context,
          CreateTenants(
            initialData: selectedTenantData,
          ));
    }
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

  @override
  Widget build(BuildContext context) {
    return CustomDataTableLayout(
      headingText: "Tenants Information",
      buttonText: "Create New",
      onButtonTap: () {
        // Handle the "Create New" button tap
        showCustomDialog(context, CreateTenants());
      },
      searchController: searchController,
      onSearchTextChanged: (value) => _filterTableData(value),
      onEditButtonTap: () {
        // Handle the "Edit" button tap
        final selectedTenantIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => propertyTableData[entry.key]['Document ID'])
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
                title: Text('Edit Tenant'),
                content: Text('Please select exactly one tenant to edit.'),
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
        print('propertyTableData length: ${propertyTableData.length}');
        print('selectedRows length: ${selectedRows.length}');
        // Handle the "Delete" button tap

        final selectedTenantIds = selectedRows
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => propertyTableData[entry.key]['Document ID'])
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
                title: Text('Delete Tenant'),
                content: Text('Please select at least one tenant to delete.'),
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
          size: ColumnSize.S,
          label: Checkbox(
            value: _areAnyRowsSelected(),
            onChanged: _selectAllRows,
          ),
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
         DataColumn2(
          label: Text('Tenant ID'),
          numeric: false,
          tooltip: 'Tenant ID',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          label: Text('Tenant Name'),
          numeric: false,
          tooltip: 'Tenant Name',
          onSort: (columnIndex, ascending) {
            // Implement sorting logic here
          },
        ),
        DataColumn2(
          label: Text('Trade License no'),
          tooltip: 'Trade License no',
        ),
        DataColumn2(
          label: Text('Mobile No'),
          tooltip: 'Mobile No',
        ),
        DataColumn2(
          label: Text('Emirates ID'),
          tooltip: 'Emirates ID',
        ),
        DataColumn2(
          label: Text('Nationality'),
          tooltip: 'Nationality',
        ),
        DataColumn2(
          label: Text('Email'),
          tooltip: 'Email',
        ),
        DataColumn2(
          label: Text('TRN No'),
          tooltip: 'TRN No',
        ),
        DataColumn2(
          label: Text('Registered'),
          tooltip: 'Registered',
        ),
        /*    DataColumn2(
          label: Text('Tenant ID'),
          tooltip: 'Tenant ID',
        ), */
        DataColumn2(
          label: Text('Address'),
          tooltip: 'Address',
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
                  entry.value['Tenant ID']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Tenant Name']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Trade License no']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Mobile No']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Emirates ID']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Nationality']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Email']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['TRN No']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                customDataCell(
                  entry.value['Registered']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
                /*   customDataCell(
                  entry.value['Tenant ID']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ), */
                customDataCell(
                  entry.value['Address']!,
                  Dimensions.dataCellWidth,
                  Dimensions.Txtfontsize,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}


/* 
final List<Map<String, String>> propertyTableData = [
  {
    'Tenant Name': 'John Doe',
    'Trade License no': 'ABC123',
    'Mobile No': '1234567890',
    'Emirates ID': '123456789012345',
    'Nationality': 'US',
    'Email': 'john.doe@example.com',
    'TRN No': 'TRN12345',
    'Registered': 'Yes',
    'Tenant ID': '1',
    'Addresss': '123 Main St, City'
  },
  {
    'Tenant Name': 'John Doe',
    'Trade License no': 'ABC123',
    'Mobile No': '1234567890',
    'Emirates ID': '123456789012345',
    'Nationality': 'US',
    'Email': 'john.doe@example.com',
    'TRN No': 'TRN12345',
    'Registered': 'Yes',
    'Tenant ID': '1',
    'Addresss': '123 Main St, City'
  },
  {
    'Tenant Name': 'John Doe',
    'Trade License no': 'ABC123',
    'Mobile No': '1234567890',
    'Emirates ID': '123456789012345',
    'Nationality': 'US',
    'Email': 'john.doe@example.com',
    'TRN No': 'TRN12345',
    'Registered': 'Yes',
    'Tenant ID': '1',
    'Addresss': '123 Main St, City'
  },
  {
    'Tenant Name': 'John Doe',
    'Trade License no': 'ABC123',
    'Mobile No': '1234567890',
    'Emirates ID': '123456789012345',
    'Nationality': 'US',
    'Email': 'john.doe@example.com',
    'TRN No': 'TRN12345',
    'Registered': 'Yes',
    'Tenant ID': '1',
    'Addresss': '123 Main St, City'
  },
  {
    'Tenant Name': 'John Doe',
    'Trade License no': 'ABC123',
    'Mobile No': '1234567890',
    'Emirates ID': '123456789012345',
    'Nationality': 'US',
    'Email': 'john.doe@example.com',
    'TRN No': 'TRN12345',
    'Registered': 'Yes',
    'Tenant ID': '1',
    'Addresss': '123 Main St, City'
  },
  // Add more data entries as needed
];
 */
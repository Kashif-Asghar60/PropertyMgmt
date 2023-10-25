import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propertymgmt_uae/src/constants.dart';
/* 
class TenantsData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchTenantData() async {
    final User? user = _auth.currentUser;
    final List<Map<String, String>> propertyTableData = [];

    if (user != null) {
      final userId = user.uid;
      final querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Tenants')
          .get();

      propertyTableData.addAll(querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Tenant Name': data['tenantName'] as String,
          'Trade License no': data['tenantLicenseNo'] as String,
          'Mobile No': data['mobileNo'] as String,
          'Emirates ID': data['emiratesId'] as String,
          'Nationality': data['nationality'] as String,
          'Email': data['email'] as String,
          'TRN No': data['trnNo'] as String,
          'Registered': data['registrationNo'] as String,
          //   'Tenant ID': doc.id,
          'Addresss': data['address'] as String,
        };
      }).toList());
    }

    return propertyTableData;
  }

  Future<void> deleteTenant(String tenantId) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Tenants')
          .doc(tenantId)
          .delete();
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting tenant: $e');
    }
  }
}
 */

class TenantData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchTenantData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;
      final querySnapshot = await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Tenants')
          .get();

      final propertyTableData = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'Tenant Name': data['Tenant Name'] as String,
          'Trade License no': data['Trade License no'] as String,
          'Mobile No': data['Mobile No'] as String,
          'Emirates ID': data['Emirates ID'] as String,
          'Nationality': data['Nationality'] as String,
          'Email': data['Email'] as String,
          'TRN No': data['TRN No'] as String,
          'Registered': data['Registered'] as String,
          'Tenant ID': doc.id,
          'Address': data['Address'] as String,
        };
      }).toList();

/*       // Initialize selectedRows with false for each row
      List<bool> selectedRows =
          List.generate(propertyTableData.length, (index) => false); */

      // Set filteredData initially to the same as propertyTableData
      List<Map<String, String>> filteredData = List.from(propertyTableData);

      return propertyTableData;
    }

    return [];
  }

  Future<void> deleteTenant(String tenantId) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(_auth.currentUser!.uid)
          .collection(FirebaseConstants.tenants)
          .doc(tenantId)
          .delete();
    } catch (e) {
      print('Error deleting tenant: $e');
    }
  }

  // Add other methods as needed...
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propertymgmt_uae/src/screens/Tenents/Data/tenents_data.dart';

import '../../constants.dart';
import '../Parties/Parties_Create.dart';
import '../Tenents/Data/model.dart';
import '../Units/units_create.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TennatUIuID
Future<String> generateTenantID() async {
  // Get the Firestore reference for tenant ID generation (using the 'tenants' collection)
  final userId = _auth.currentUser?.uid;
  final tenantIDGeneratorRef = _firestore
      .collection(FirebaseConstants.users)
      .doc(userId)
      .collection(FirebaseConstants.tenants);

  // Check if the "latestTenantID" document exists
  final latestTenantIDDoc = tenantIDGeneratorRef.doc("latestTenantID");
  final latestTenantIDDocSnapshot = await latestTenantIDDoc.get();

  // Use a Firestore transaction to generate a unique sequential ID
  final tenantID = await _firestore.runTransaction<String>((transaction) async {
    if (!latestTenantIDDocSnapshot.exists) {
      // If the document doesn't exist, create it with an initial value
      transaction.set(latestTenantIDDoc, {"latestTenantID": "T-00"});
    }

    // Extract the numeric part of the latest ID and increment it
    final lastNumber = int.parse(latestTenantIDDocSnapshot.data()?["latestTenantID"].split('-')[1]);
    final newNumber = lastNumber + 1;
    final newID = 'T-${newNumber.toString().padLeft(2, '0')}';

    // Update the latest tenant ID in Firestore
    transaction.update(latestTenantIDDoc, {"latestTenantID": newID});

    return newID;
  });

  return tenantID;
}

  //DD
  Future<List<String>> fetchProjectPartyItems() async {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.masterParty);

      final snapshot = await collectionReference.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data[PartyFormData.partyNameField] as String;
      }).toList();
    } else {
      return [];
    }
  }
  //DD
  Future<List<String>> fetchPropertyNameItems() async {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.rentalUnits);

      final snapshot = await collectionReference.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data[UnitFormData.propertyField] as String;
      }).toList();
    } else {
      return [];
    }
  }
  //DD
Future<List<TenantInfo>> fetchTenantNameItems() async {
  final User? user = _auth.currentUser;
  final userId = user?.uid;

  if (userId != null) {
    final collectionReference = _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.tenants);

    final snapshot = await collectionReference.get();

    return snapshot.docs
        .where((doc) => doc.data()["Tenant Name"] != null)
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return TenantInfo(id: doc.id, name: data["Tenant Name"] as String);
        })
        .toList();
  } else {
    return [];
  }
}


  //DD
  Future<List<String>> fetchUnitNameItems() async {
    final User? user = _auth.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      final collectionReference = _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.rentalUnits);

      final snapshot = await collectionReference.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data[UnitFormData.unitNameField] as String;
      }).toList();
    } else {
      return [];
    }
  }
}

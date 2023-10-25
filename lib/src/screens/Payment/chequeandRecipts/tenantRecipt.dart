import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../Tenents/Data/model.dart';
import '../customstyle/text_custom.dart';
import '../payment_create.dart';

class TenantHistoryCheque extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const TenantHistoryCheque({Key? key, this.initialData}) : super(key: key);

  @override
  State<TenantHistoryCheque> createState() => _TenantHistoryChequeState();
}

class _TenantHistoryChequeState extends State<TenantHistoryCheque> {
  String? tenantID, unitName;
  PaymentCreateData? paymentData;
    Tenant tenant = Tenant(
    tenantName: "Loading...", // Initial value
    tenantLicenseNo: "",
    mobileNo: "",
    emiratesId: "",
    nationality: "",
    email: "",
    trnNo: "",
    registrationNo: "",
    address: "",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if (widget.initialData != null) {
      paymentData = PaymentCreateData.fromMap(widget.initialData!);
      populateData();
      fetchTenantData(paymentData!.selectedTenantId!).then((tenantData) {
        setState(() {
          tenant = tenantData;
        });
      });
    }
  }

  void populateData() {
    tenantID = paymentData!.selectedTenantId;
      unitName =  paymentData!.unitName;
  }

       

  @override
  Widget build(BuildContext context) {
    print("ccc$tenant");
    // tenant cheque dimensions
    double tenantCollectionChequeHeight = Dimensions.screenHeight / 3.7;
    double tenantCollectionChequeWidth = Dimensions.screenWidth / 1.4;
    double tenantCollectionTopbarHeight = Dimensions.screenHeight / 11.8;

    double tenantCollectionSizeboxHeight = Dimensions.sizeboxWidth * 2;

    /// 2nd half tenant
    double tenanttCollection2ndHalfContainer1Width =
        Dimensions.screenWidth / 10;

    double tenantCollection2ndHalfContainer2Width = Dimensions.screenWidth / 2;
    double tenantCollection2ndHalfContainer2Height =
        Dimensions.screenHeight / 5.5;
    double elementsheight = 5;
/* //sub  Height
      double tenantCollection2ndHalfContainer2Height2 =Dimensions.screenHeight / 10.5; 
      double tenantCollection2ndHalfContainer2Height3 =Dimensions.screenHeight / 13  ;  */

    return Container(
      width: tenantCollectionChequeWidth,
      height: tenantCollectionChequeHeight,
      decoration: BoxDecoration(

          // color: Colors.amber,
          border:
              Border.all(color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: tenantCollectionTopbarHeight,
              //margin: EdgeInsets.all(4),
              color: AppConstants.purplethemecolor,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.only(left: Dimensions.screenWidth / 4.5),
                      child: const Center(
                          child: BolDCustomText(
                              text: "Tenant History",
                              color: AppConstants.whiteTxtColor)),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 6, 0),
                      child: Column(
                        children: [
                          Flexible(
                            child: NormalCustomText(
    text: "PrintDate: ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                                color: AppConstants.whiteTxtColor),
                          ),
                          SizedBox(
                            height: tenantCollectionSizeboxHeight,
                          ),
                          Flexible(
                            child: NormalCustomText(
    text: "PrintTime: ${DateFormat('hh:mm:ss a').format(DateTime.now())}",
                                color: AppConstants.whiteTxtColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: tenantCollection2ndHalfContainer2Height,
                  width: tenanttCollection2ndHalfContainer1Width,
                  decoration: BoxDecoration(
                      //           color: Color.fromARGB(221, 152, 99, 99),
                      border: Border(right: BorderSide(color: Colors.black))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                  child: SizedBox(
                    width: tenantCollection2ndHalfContainer2Width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //  crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TenantRowWidget(
                          L: "${tenantID}",
                          LR: "Mobile No: ",
                          R: "${tenant.mobileNo}",
                        ),
                        SizedBox(
                          height: elementsheight,
                        ),
                        TenantRowWidget(
                          L: "$unitName",
                          LR: "TRN No: ",
                          R: "${tenant.trnNo}",
                        ),
                        SizedBox(
                          height: elementsheight,
                        ),
                        TenantRowWidget(
                          L: "Nationality: ${tenant.nationality}",
                          LR: "Emirates ID: ",
                          R: "${tenant.emiratesId}",
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TenantRowWidget extends StatelessWidget {
  TenantRowWidget({
    required this.L,
    required this.LR,
    required this.R,
  });
  final String L, LR, R;

  @override
  Widget build(BuildContext context) {
    return Row(
      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NormalCustomText(text: L),
        Spacer(),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalCustomText(text: LR),
              NormalCustomText(text: R),
            ],
          ),
        ),
        //   NormalCustomText(text: right),
      ],
    );
  }
}



Future<Tenant> fetchTenantData(String tenantID) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final userId = user?.uid;
print("object $tenantID");
  if (userId != null) {
    final collectionReference = _firestore
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.tenants);

    final docReference = collectionReference.doc(tenantID);
    final docSnapshot = await docReference.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      return Tenant.fromMap(data);
    }
  }

  // Handle the case where the document doesn't exist or an error occurs.
  // You can return a default Tenant object or take appropriate action.
  return Tenant(
    tenantName: "Unknown Tenant Name",
    tenantLicenseNo: "",
    mobileNo: "",
    emiratesId: "",
    nationality: "",
    email: "",
    trnNo: "",
    registrationNo: "",
    address: "",
  );
}

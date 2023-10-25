import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:propertymgmt_uae/src/providers/dimensions_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../customstyle/text_custom.dart';
import '../payment_create.dart';

class PaymentCollectionCheque extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const PaymentCollectionCheque({Key? key, this.initialData}) : super(key: key);

  @override
  State<PaymentCollectionCheque> createState() =>
      _PaymentCollectionChequeState();
}

class _PaymentCollectionChequeState extends State<PaymentCollectionCheque> {
  String? collectionNo,
      collectionDate,
      tenant,
      project,
      paymentMethod,
      chequeDate,
      chequeNo,
      unitName,
      bankName,
      preBalance,
      discount,
      paidAmount,
      balance;
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialData != null) {
      //print("iinin data ${widget.initialData}");
      paymentData = PaymentCreateData.fromMap(
          widget.initialData!); // Initialize the tenant object
      populateData(); // Populate controllers from tenant object
    }
  }

  PaymentCreateData? paymentData;
  void populateData() {
    collectionNo = paymentData!.collectionNo;
     collectionDate =  paymentData!.collectionDate;
      tenant =  paymentData!.tenantSelectedVal;
      project =  paymentData!.projectSelectedVal;
      paymentMethod =  paymentData!.paymentMethodSelectedVal; 
      chequeDate =  paymentData!.chequeDate;
      chequeNo =  paymentData!.chequeNo;
      unitName =  paymentData!.unitName;
      bankName =  paymentData!.bankName;
      preBalance =  paymentData!.preBalance;
      discount =  paymentData!.discount;
      paidAmount  =paymentData!.paidAmount;
      balance =  paymentData!.balance;
  }
  @override
  Widget build(BuildContext context) {
    //       final Dimensions = Provider.of<DimensionsProvider>(context , listen: false);
    // payment cheque dimensions
    double paymentCollectionChequeHeight = Dimensions.screenHeight / 3.7;
    double paymentCollectionTopbarHeight = Dimensions.screenHeight / 11.8;
    double paymentCollectionChequeWidth = Dimensions.screenWidth / 1.4;
    double paymentCollectionSizeboxHeight = Dimensions.sizeboxWidth * 2;

    /// 2nd half payment
    double paymentCollection2ndHalfContainer1Width =
        Dimensions.screenWidth / 10;

    double paymentCollection2ndHalfContainer2Width =
        Dimensions.screenWidth / 2.6;
    double paymentCollection2ndHalfContainer2Height =
        Dimensions.screenHeight / 5.5;
    double elementsheight = 5;
//sub  Height
    double paymentCollection2ndHalfContainer2Height2 =
        Dimensions.screenHeight / 10.5;
    double paymentCollection2ndHalfContainer2Height3 =
        Dimensions.screenHeight / 13;
    double paymentCollection2ndHalfContainer3Width =
        Dimensions.screenWidth / 4.5;

    return Container(
      decoration: BoxDecoration(
          //       color: Colors.amber,
          border: Border.all(color: Colors.black, width: 1)),
      width: paymentCollectionChequeWidth,
      height: paymentCollectionChequeHeight,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //top
            Container(
              height: paymentCollectionTopbarHeight,
              //margin: EdgeInsets.all(4),
              color: AppConstants.purplethemecolor,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: paymentCollection2ndHalfContainer3Width),
                      child: const Center(
                          child: BolDCustomText(
                              text: "Payment Collection",
                              color: AppConstants.whiteTxtColor)),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                       Flexible(
                            child: NormalCustomText(
    text: "PrintDate: ${DateFormat('dd MMM yyyy').format(DateTime.now())}",
                                color: AppConstants.whiteTxtColor),
                          ),
                          SizedBox(
                            height:  paymentCollectionSizeboxHeight,
                          ),
                          Flexible(
                            child: NormalCustomText(
    text: "PrintTime: ${DateFormat('hh:mm:ss a').format(DateTime.now())}",
                                color: AppConstants.whiteTxtColor),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //cntre half white
            Row(
              children: [
                Container(
                  height: paymentCollection2ndHalfContainer2Height,
                  width: paymentCollection2ndHalfContainer1Width,
                  //    color: Colors.blue,
                ),
                Container(
                  height: paymentCollection2ndHalfContainer2Height,
                  width: paymentCollection2ndHalfContainer2Width,
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black))),
                  //  color: Colors.red,
                  child: Column(children: [
                    //1st half
                    Container(
                      height: paymentCollection2ndHalfContainer2Height2,
                      //     color: Color.fromRGBO(149, 144, 144, 0.867),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingcheque * 6,
                              vertical: Dimensions.paddingcheque * 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               NormalCustomText(
                                text: "$tenant",
                              ),
                              SizedBox(height: elementsheight),
                               NormalCustomText(
                                text: "$project",
                              ),
                              SizedBox(
                                height: elementsheight,
                              ),
                               Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                               const   NormalCustomText(
                                    text: "Unit No:  ___",
                                  ),
                                  NormalCustomText(
                                    text: "Unit Name: $unitName",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //2nd half
                    Container(
                      decoration: const BoxDecoration(
                          //           color: Color.fromARGB(221, 152, 99, 99),
                          border: Border(top: BorderSide(color: Colors.black))),
                      height: paymentCollection2ndHalfContainer2Height3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingcheque * 6,
                              vertical: Dimensions.paddingcheque * 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  NormalCustomText(
                                    text: "Cheque Date: $chequeDate",
                                  ),
                                  NormalCustomText(
                                    text: "Cheque No: $chequeNo",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              NormalCustomText(
                                text: "Bank Name: $bankName",
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                Container(
                  height: paymentCollection2ndHalfContainer2Height,
                  width: paymentCollection2ndHalfContainer3Width,
                  //       color: Colors.cyan,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.paddingcheque * 10,
                          horizontal: Dimensions.paddingcheque * 7),
                      child: Column(children: [
                         RightChequeDetailWidget(
                            left: "Pre Balance", right: "$preBalance"),
                        SizedBox(height: elementsheight),
                         RightChequeDetailWidget(
                            left: "Paid Amount", right: "$paidAmount"),
                        SizedBox(height: elementsheight),
                         RightChequeDetailWidget(
                            left: "Discount", right: "$discount"),
                        SizedBox(height: elementsheight),
                         RightChequeDetailWidget(
                            left: "Payment Mode", right: "$paymentMethod"),
                        SizedBox(height: elementsheight),
                         RightChequeDetailWidget(
                            left: "Balance", right: "$balance"),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RightChequeDetailWidget extends StatelessWidget {
  const RightChequeDetailWidget(
      {super.key, required this.left, required this.right});
  final String left, right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NormalCustomText(text: left),
        NormalCustomText(text: right),
      ],
    );
  }
}

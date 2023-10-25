



import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../customstyle/text_custom.dart';
import '../payment_create.dart';

class CustomSheetTable extends StatefulWidget {

    final Map<String, dynamic>? initialData;

  const CustomSheetTable({Key? key, this.initialData}) : super(key: key);


  @override
  State<CustomSheetTable> createState() => _CustomSheetTableState();
}

class _CustomSheetTableState extends State<CustomSheetTable> {
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
    PaymentCreateData? paymentData;
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if (widget.initialData != null) {
      paymentData = PaymentCreateData.fromMap(widget.initialData!);
      populateData();
     
    }
  }
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
     // sheet cheque dimensions
       double sheetCollectionChequeHeight = Dimensions.screenHeight/8;
        double sheetCollectionChequeWidth =Dimensions.screenWidth / 1.4;
       double sheetCollectionTopbarHeight = Dimensions.screenHeight/11.8;
  
   double sheetCollectionSizeboxHeight  =Dimensions.sizeboxWidth*2;
    double elementsheight=5;
    return Container(
      width:  sheetCollectionChequeWidth,
      height: sheetCollectionChequeHeight,
      decoration: BoxDecoration(
            
           // color: Colors.amber,
          border: Border.all(color: const Color.fromRGBO(0, 0, 0, 1), width: 1)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                 Row(
              children: [
                _buildCell("SR #" , "1" , leftBorder: false),
            _buildCell("Collection Date", "$collectionDate"),
            _buildCell("Collection No", "$collectionNo"),
            _buildCell("Unit No", "$unitName"),
            _buildCell("Pre Balance", "$preBalance"),
            _buildCell("Paid Amount", "$paidAmount"),
            _buildCell("Discount", "$discount"),
            _buildCell("Balance", "$balance", rightBorder: false), 
              ],
                ),
          
              SizedBox(
                height: elementsheight,
              ),
              //2nd half
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  NormalCustomText(text: "Grand Total"),
                   NormalCustomText(text: "100,000.00")
              ],)
              ]
             
            ),
          ),
    );
  }

   /* */
  Widget _buildCell(String columnName, String dataName, {bool leftBorder = true, bool rightBorder = true}) {
    BorderSide leftBorderSide = leftBorder
        ? BorderSide(color: const Color.fromRGBO(0, 0, 0, 1), width: 0.5)
        : BorderSide.none;
    BorderSide rightBorderSide = rightBorder
        ? BorderSide(color: const Color.fromRGBO(0, 0, 0, 1), width: 0.5)
        : BorderSide.none;

 double sheetCellHeight = Dimensions.screenHeight/15;
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: sheetCellHeight/1.5,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color.fromRGBO(0, 0, 0, 1), width: 0.5),
                left: leftBorderSide,
                right: rightBorderSide,
               
              ),
              color: AppConstants.purplethemecolor, // You can change the color here.
            ),
            child: Center(
              child:NormalCustomText(text: columnName, color: AppConstants.whiteTxtColor,),
            ),
          ),
          Container(
            height: sheetCellHeight/1.7,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: const Color.fromRGBO(0, 0, 0, 1), width: 0.5),
                left: leftBorderSide,
                right: rightBorderSide,
                 bottom:  BorderSide(color: const Color.fromRGBO(0, 0, 0, 1), width: 0.5),
              ),
            ),
            child: Center(
              child: NormalCustomText(text: dataName)
            ),
          ),
        ],
      ),
    );
  }
}



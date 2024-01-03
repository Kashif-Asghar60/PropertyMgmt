import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../../constants.dart';
import '../../../widgets/CustomTextandFields/customTextField.dart';
import '../../../widgets/customTextforfield.dart';

class JournalCreateVoucher extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const JournalCreateVoucher({Key? key, this.initialData}) : super(key: key);

  @override
  State<JournalCreateVoucher> createState() => _JournalCreateVoucherState();
}

class _JournalCreateVoucherState extends State<JournalCreateVoucher> {
  int height = 5;
 bool isContainerVisible = false;
  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(heading: "Journal Voucher", centerContent: [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Dimensions.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Dimensions.widthTxtField * 1.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: "Voucher Type",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true,
                        ),
                        SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                        SizedBox(
                            width: Dimensions.widthTxtField,
                            child: Row(
                              children: [
                                CustomTextField(
                                  hintText: "Type",
                                  width: Dimensions.widthTxtField / 2.3,
                                  backgroundColor: AppConstants.whitecontainer,
                                  controller: null,
                                ),
                                SizedBox(
                                    width: Dimensions.spaceBetweenTxtField * 1.3),
                                CustomTextField(
                                  hintText: "1371",
                                  width: Dimensions.widthTxtField / 2.3,
                                  backgroundColor: AppConstants.whitecontainer,
                                  controller: null,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    //  color: Colors.greenAccent,
                    width: Dimensions.screenWidth / 2,
                    child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            // color: Colors.red,
                            // height: 60,
                            width: Dimensions.widthTxtField),
                        CustomTextWidget(
                          text: "Currency",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true,
                        ),
                        SizedBox(width: Dimensions.spaceBetweenTxtField * 1.6),
                      SizedBox(
                        //color: Colors.amber,
                            width: Dimensions.widthTxtField,
                            child: Row(
                              children: [
                                CustomTextField(
                                  hintText: "AED",
                                  width: Dimensions.widthTxtField / 2.3,
                                  backgroundColor: AppConstants.whitecontainer,
                                  controller: null,
                                ),
                                SizedBox(
                                    width: Dimensions.spaceBetweenTxtField * 1.3),
                                CustomTextField(
                                  hintText: "137,000.00",
                                  width: Dimensions.widthTxtField / 2.3,
                                  backgroundColor: AppConstants.whitecontainer,
                                  controller: null,
                                ),
                              ],
                            ))
                        //    SizedBox(width: Dimensions.spaceBetweenTxtField / 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: Dimensions.sizeboxWidth * height),
        
            /// DATE AND ENTERED BY
            SizedBox(
              width: Dimensions.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Dimensions.widthTxtField * 1.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: "Voucher Date",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true,
                        ),
                        SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                        CustomTextField(
                          hintText: "Date",
                          width: Dimensions.widthTxtField,
                          backgroundColor: AppConstants.whitecontainer,
                          controller: null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    //  color: Colors.greenAccent,
                    width: Dimensions.screenWidth / 2,
                    child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            // color: Colors.red,
                            // height: 60,
                            width: Dimensions.widthTxtField),
                        CustomTextWidget(
                          text: "Entered by",
                          fontSize: Dimensions.Txtfontsize,
                          fontWeight: FontWeight.w500,
                          showStar: true,
                        ),
                        SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                        CustomTextField(
                          hintText: "Enter Name",
                          width: Dimensions.widthTxtField,
                          backgroundColor: AppConstants.whitecontainer,
                          controller: null,
                        ),
        
                        //    SizedBox(width: Dimensions.spaceBetweenTxtField / 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        
          IconButton(
                    iconSize: 20,
                    onPressed: () {
                      setState(() {
                        isContainerVisible = !isContainerVisible;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                   Visibility(
                visible:isContainerVisible,
                child: Container(
                  // Your container content goes here
                  // For example, you can add more text fields or widgets
                  width: Dimensions.screenWidth ,
                  padding: EdgeInsets.all(16.0),
                  color:  AppConstants.content_areaClr.withOpacity(0.3),
                  child:Column(children: [
                         SizedBox(height: Dimensions.sizeboxWidth * height),

        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Mode",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "Debit",
                      controller: null,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Branch",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "Branch abc",
                      controller: null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
     // AC CODE   Exp
                        SizedBox(height: Dimensions.sizeboxWidth * height),

        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "AC Code",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "MA004",
                      controller: null,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Exp",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
     // _ Value Date
                        SizedBox(height: Dimensions.sizeboxWidth * height),

        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "           ",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: false),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "Abu Abdullah",
                      controller: null,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Value Date",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "01/01/2024",
                      controller: null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
     // Amount FC Currency
                        SizedBox(height: Dimensions.sizeboxWidth * height),

        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Amount FC",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: false),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                                              hintText:"10.00",

                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      controller: null,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
            //currency
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Balance Amount",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: false,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
     //Invoice Date   .. Invoice no 
                        SizedBox(height: Dimensions.sizeboxWidth * height),

        SizedBox(
          //  color: Colors.yellow,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              SizedBox(
                width: Dimensions.widthTxtField * 1.6,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                        text: "Invoice Date",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: null,
                    )
                  ],
                ),
              ),
              SizedBox(width: Dimensions.rowspaceBetweenTxtField),
              SizedBox(
                width: Dimensions.widthTxtField * 1.65,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: "Invoice no",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "",
                      controller: null,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

                        SizedBox(height: Dimensions.sizeboxWidth * height),

     // remarks
         Align(
          alignment: Alignment.topLeft,
           child: SizedBox(
            height:Dimensions.buttonHeight *3 ,
              width: Dimensions.screenWidth/2,
              child: CustomTextField(
                minLines: 3,
                maxLines: 5,
                width: Dimensions.widthTxtField * 5,
                backgroundColor: AppConstants.whitecontainer,
                hintText: "Remarks",
                controller: null, // Address controller
             
              ),
            ),
         ),
                  ],)
                ),
              ),
          ],
        ),
      )
    ]);
  }
}



class JournalCreateVoucherModelData {
  static const String voucherTypeField = 'VoucherType';
  static const String currencyField = 'Currency';
  static const String voucherDateField = 'VoucherDate';
    static const String voucherNoField = 'VoucherNo';

  static const String enteredByField = 'EnteredBy';
  static const String modeField = 'Mode';
  static const String branchField = 'Branch';
  static const String acCodeField = 'ACCode';
    static const String acHeadField = 'ACHead';

  static const String expField = 'Exp';
  static const String valueDateField = 'ValueDate';
  static const String amountFCField = 'AmountFC';
  static const String balanceAmountField = 'BalanceAmount';
  static const String invoiceDateField = 'InvoiceDate';
  static const String invoiceNoField = 'InvoiceNo';
  static const String remarksField = 'Remarks';

  final String voucherType;
  final String currency;
  final String voucherDate;
  final String voucherNo;
  final String enteredBy;
  final String mode;
  final String branch;
  final String acCode;
    final String acHead;

  final String exp;
  final String valueDate;
  final String amountFC;
  final String balanceAmount;
  final String invoiceDate;
  final String invoiceNo;
  final String remarks;

  JournalCreateVoucherModelData({
    required this.voucherType,
    required this.currency,
    required this.voucherDate,
    required this.voucherNo,
    required this.enteredBy,
    required this.mode,
    required this.branch,
    required this.acCode,
    required this.acHead,
    required this.exp,
    required this.valueDate,
    required this.amountFC,
    required this.balanceAmount,
    required this.invoiceDate,
    required this.invoiceNo,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      voucherTypeField: voucherType,
      currencyField: currency,
      voucherDateField: voucherDate,
      voucherNoField:voucherNo,
      enteredByField: enteredBy,
      modeField: mode,
      branchField: branch,
      acCodeField: acCode,
      acHeadField:acHead,
      expField: exp,
      valueDateField: valueDate,
      amountFCField: amountFC,
      balanceAmountField: balanceAmount,
      invoiceDateField: invoiceDate,
      invoiceNoField: invoiceNo,
      remarksField: remarks,
    };
  }

  factory JournalCreateVoucherModelData.fromMap(Map<String, dynamic> map) {
    return JournalCreateVoucherModelData(
      voucherType: map[voucherTypeField] ?? '',
      currency: map[currencyField] ?? '',
      voucherNo: map[voucherNoField]??'',
      voucherDate: map[voucherDateField] ?? '',
      enteredBy: map[enteredByField] ?? '',
      mode: map[modeField] ?? '',
      branch: map[branchField] ?? '',
      acCode: map[acCodeField] ?? '',
      acHead: map[acHeadField]?? '',
      exp: map[expField] ?? '',
      valueDate: map[valueDateField] ?? '',
      amountFC: map[amountFCField] ?? '',
      balanceAmount: map[balanceAmountField] ?? '',
      invoiceDate: map[invoiceDateField] ?? '',
      invoiceNo: map[invoiceNoField] ?? '',
      remarks: map[remarksField] ?? '',
    );
  }
}

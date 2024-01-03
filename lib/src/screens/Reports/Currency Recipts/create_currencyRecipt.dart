import 'package:flutter/material.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import 'package:propertymgmt_uae/src/widgets/CustomCreate/CreateLayout.dart';

import '../../../widgets/CustomTextandFields/customTextField.dart';
import '../../../widgets/CustomTextandFields/dropdown.dart';
import '../../../widgets/customTextforfield.dart';

class Create_CurrencyReciept extends StatefulWidget {
final Map<String, dynamic>? initialData;

  const Create_CurrencyReciept({Key? key, this.initialData}) : super(key: key);

  @override
  State<Create_CurrencyReciept> createState() => _Create_CurrencyRecieptState();
}

class _Create_CurrencyRecieptState extends State<Create_CurrencyReciept> {
   int height = 5;
    bool isContainerVisible = false;
List<String> localValues = ['Cash', 'Cheque'];
  String? ModeSelectedVal;

  @override
  Widget build(BuildContext context) {
    return CustomFormContainer(heading: "Header Details", centerContent: 
    [
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
                              ),),
                              
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
              )
            ),
             SizedBox(height: Dimensions.sizeboxWidth * height),
          // date and pos Customer
                  SizedBox(
                width: Dimensions.screenWidth ,
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
                            text: "POS Customer",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField /4 ),
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
             SizedBox(height: Dimensions.sizeboxWidth * height),
            // Party Code 1 .. Party Currency 
         
         SizedBox(
              width: Dimensions.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                         SizedBox(
                      //  color: Colors.greenAccent,
                      width: Dimensions.screenWidth / 2,
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
         
                        children: [
                         
                          CustomTextWidget(
                            text: "Party Code",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField * 2.7),
                          CustomTextField(
                            hintText: "Code 321",
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            controller: null,
                          ),
          
                        ],
                      ),
                    ),
           
                   SizedBox(
                      width: Dimensions.widthTxtField * 1.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            text: "      Party Currency",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                         SizedBox(width: Dimensions.spaceBetweenTxtField /2),
                          SizedBox(
                              width: Dimensions.widthTxtField,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextField(
                                    hintText: "AED",
                                    width: Dimensions.widthTxtField / 3.3,
                                    backgroundColor: AppConstants.whitecontainer,
                                    controller: null,
                                  ),
                                  SizedBox(
                                      width: Dimensions.spaceBetweenTxtField /4),
                                  CustomTextField(
                                    hintText: "100,000.00",
                                    width: Dimensions.widthTxtField / 2.3,
                                    backgroundColor: AppConstants.whitecontainer,
                                    controller: null,
                                  ),
                                ],
                              ),),
                              
                        ],
                      ),
                    ),
         
                      
                ],
              )
            ),
                   SizedBox(height: Dimensions.sizeboxWidth * height),
              // Party Code 2 /// Reference #
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
                            text: "           ",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: false,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                          CustomTextField(
                            hintText: "Code 2....",
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
                            text: "Reference #",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField ),
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
             SizedBox(height: Dimensions.sizeboxWidth * height),
          
               // Party  Code 3 /// Reference Date
               SizedBox(
                width: Dimensions.screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Dimensions.widthTxtField * 1.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: "           ",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: false,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                          CustomTextField(
                            height: Dimensions.buttonHeight *2,
                            hintText: "Code 3....",
                            width: Dimensions.widthTxtField,
                            minLines: 3,
                            maxLines: 4,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              // color: Colors.red,
                              // height: 60,
                              width: Dimensions.widthTxtField),
                          CustomTextWidget(
                            text: "Reference Date",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField /7),
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
             SizedBox(height: Dimensions.sizeboxWidth * height),
          //  TN No 
            SizedBox(
                width: Dimensions.screenWidth/2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Dimensions.widthTxtField * 1.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: "TN No",
                            fontSize: Dimensions.Txtfontsize,
                            fontWeight: FontWeight.w500,
                            showStar: true,
                          ),
                          SizedBox(width: Dimensions.spaceBetweenTxtField * 1.3),
                          CustomTextField(
                            hintText: "TRN No",
                            width: Dimensions.widthTxtField,
                            backgroundColor: AppConstants.whitecontainer,
                            controller: null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
           
                  IconButton(
                    iconSize: 60,
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
                
                    CustomDropdownTextField(
  width: Dimensions.widthTxtField,
  label: "",
  items: localValues,
  value: ModeSelectedVal ?? localValues.first, // Set a default value
  onChanged: (newValue) {
    setState(() {
      ModeSelectedVal = newValue;
    });
  },
  backgroundColor: AppConstants.whitecontainer,
),
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
                        text: "AC Head",
                        fontSize: Dimensions.Txtfontsize,
                        fontWeight: FontWeight.w500,
                        showStar: true),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "12000",
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
                      hintText: "Cash in hand",
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
                      text: "Currency Code",
                      fontSize: Dimensions.Txtfontsize,
                      fontWeight: FontWeight.w500,
                      showStar: true,
                    ),
                    SizedBox(width: Dimensions.spaceBetweenTxtField),
                    CustomTextField(
                      width: Dimensions.widthTxtField,
                      backgroundColor: AppConstants.whitecontainer,
                      hintText: "AED",
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
                      text: "Head Amount",
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


class CreateCurrencyReceiptData {
  static const String voucherTypeField = 'VoucherType';
  static const String voucherTypeNoField = 'VoucherTypeNo';
  static const String enteredByField = 'EnteredBy';
  static const String voucherDateField = 'VoucherDate';
  static const String posCustomerField = 'PosCustomer';
  static const String partyCodeField = 'PartyCode';
  static const String partyCode1Field = 'PartyCode1';
  static const String partyCode2Field = 'PartyCode2';
  static const String partyCurrencyField = 'PartyCurrency';
  static const String partyCurrencyAmountField = 'PartyCurrencyAmount';
  static const String referenceNumberField = 'ReferenceNumber';
  static const String referenceDateField = 'ReferenceDate';
  static const String tnNoField = 'TNNo';
  static const String modeField = 'Mode';
  static const String branchField = 'Branch';
  static const String acHeadField = 'ACHead';
  static const String expField = 'Exp';
  static const String valueDateField = 'ValueDate';
  static const String cashInHandField = 'CashInHand';
  static const String currencyCodeField = 'CurrencyCode';
  static const String amountFCField = 'AmountFC';
  static const String headAmountField = 'HeadAmount';
  static const String remarksField = 'Remarks';

  final String voucherType;
  final String voucherTypeNo;
  final String enteredBy;
  final String voucherDate;
  final String posCustomer;
  final String partyCode;
  final String partyCode1;
  final String partyCode2;
  final String partyCurrency;
  final String partyCurrencyAmount;
  final String referenceNumber;
  final String referenceDate;
  final String tnNo;
  final String mode;
  final String branch;
  final String acHead;
  final String exp;
  final String valueDate;
  final String cashInHand;
  final String currencyCode;
  final String amountFC;
  final String headAmount;
  final String remarks;

  CreateCurrencyReceiptData({
    required this.voucherType,
    required this.voucherTypeNo,
    required this.enteredBy,
    required this.voucherDate,
    required this.posCustomer,
    required this.partyCode,
    required this.partyCode1,
    required this.partyCode2,
    required this.partyCurrency,
    required this.partyCurrencyAmount,
    required this.referenceNumber,
    required this.referenceDate,
    required this.tnNo,
    required this.mode,
    required this.branch,
    required this.acHead,
    required this.exp,
    required this.valueDate,
    required this.cashInHand,
    required this.currencyCode,
    required this.amountFC,
    required this.headAmount,
    required this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      voucherTypeField: voucherType,
      voucherTypeNoField: voucherTypeNo,
      enteredByField: enteredBy,
      voucherDateField: voucherDate,
      posCustomerField: posCustomer,
      partyCodeField: partyCode,
      partyCode1Field: partyCode1,
      partyCode2Field: partyCode2,
      partyCurrencyField: partyCurrency,
      partyCurrencyAmountField: partyCurrencyAmount,
      referenceNumberField: referenceNumber,
      referenceDateField: referenceDate,
      tnNoField: tnNo,
      modeField: mode,
      branchField: branch,
      acHeadField: acHead,
      expField: exp,
      valueDateField: valueDate,
      cashInHandField: cashInHand,
      currencyCodeField: currencyCode,
      amountFCField: amountFC,
      headAmountField: headAmount,
      remarksField: remarks,
    };
  }

  factory CreateCurrencyReceiptData.fromMap(Map<String, dynamic> map) {
    return CreateCurrencyReceiptData(
      voucherType: map[voucherTypeField] ?? '',
      voucherTypeNo: map[voucherTypeNoField] ?? '',
      enteredBy: map[enteredByField] ?? '',
      voucherDate: map[voucherDateField] ?? '',
      posCustomer: map[posCustomerField] ?? '',
      partyCode: map[partyCodeField] ?? '',
      partyCode1: map[partyCode1Field] ?? '',
      partyCode2: map[partyCode2Field] ?? '',
      partyCurrency: map[partyCurrencyField] ?? '',
      partyCurrencyAmount: map[partyCurrencyAmountField] ?? '',
      referenceNumber: map[referenceNumberField] ?? '',
      referenceDate: map[referenceDateField] ?? '',
      tnNo: map[tnNoField] ?? '',
      mode: map[modeField] ?? '',
      branch: map[branchField] ?? '',
      acHead: map[acHeadField] ?? '',
      exp: map[expField] ?? '',
      valueDate: map[valueDateField] ?? '',
      cashInHand: map[cashInHandField] ?? '',
      currencyCode: map[currencyCodeField] ?? '',
      amountFC: map[amountFCField] ?? '',
      headAmount: map[headAmountField] ?? '',
      remarks: map[remarksField] ?? '',
    );
  }
}

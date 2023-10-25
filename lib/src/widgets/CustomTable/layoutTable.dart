import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants.dart';
import '../CustomTextandFields/customSearchField.dart';
import '../buttonCustom.dart';
import '../custonicon.dart';
import 'Table.dart';

class CustomDataTableLayout extends StatelessWidget {
  final String headingText;
  final String buttonText;
  final Function() onButtonTap;
  final TextEditingController searchController;
  final Function(String)? onSearchTextChanged;
  final List<DataColumn2> columns;
  // final List<GridColumn> GridColumncolumns;
  // final List<DataRow> Datarows;

  final List<DataRow2> rows;
  final Function()? onDeleteButtonTap;
  final Function()? onEditButtonTap;
  final double widthforMorecolumns;

  final bool showPrintChequeButton; // Whether to show the "Print Cheque" button
  final bool
      showPrintReceiptButton; // Whether to show the "Print Receipt" button
  final Function()? onPrintChequeTap; // Callback for "Print Cheque" button
  final Function()? onPrintReceiptTap; // Callback for "Print Receipt" button

  CustomDataTableLayout({
    this.widthforMorecolumns = 1.0,
    required this.headingText,
    required this.buttonText,
    required this.onButtonTap,
    required this.searchController,
    required this.onSearchTextChanged,
    // required this.GridColumncolumns,
    required this.columns,
    //  required this.Datarows,
    required this.rows,
    this.onDeleteButtonTap,
    this.onEditButtonTap,
    this.showPrintChequeButton = false, // Default to false
    this.showPrintReceiptButton = false, // Default to false
    this.onPrintChequeTap,
    this.onPrintReceiptTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppConstants.content_areaClr,
        padding: EdgeInsets.fromLTRB(
          Dimensions.paddingtenants,
          Dimensions.paddingtenants - 10,
          Dimensions.paddingtenants,
          Dimensions.paddingtenants * 2,
        ),
        width: Dimensions.dataTableWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Dimensions.dataTableWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headingText,
                    style: TextStyle(
                      fontSize: Dimensions.Txtfontsize * 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomButton(
                    color: AppConstants.greenbutton,
                    txtcolor: AppConstants.whiteTxtColor,
                    text: buttonText,
                    width: Dimensions.buttonWidth * 1.4,
                    height: Dimensions.buttonHeight,
                    fontSize: Dimensions.Txtfontsize,
                    onPressed: onButtonTap,
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.sizeboxWidth * 8),
            SizedBox(
              width: Dimensions.dataTableWidth,
              child: Row(
                children: [
                  Baseline(
                    baseline: 0.0,
                    baselineType: TextBaseline.alphabetic,
                    child: CustomSearchTextField(
                      onChanged: onSearchTextChanged,
                      controller: searchController,
                      hintText: "Search",
                      width: Dimensions.widthTxtField,
                      borderColor: AppConstants.purplethemecolor,
                    ),
                  ),
                  const Spacer(),
                  HoverIconButton(
                    splashColor: Colors.red.shade700.withOpacity(.4),
                    icon: Icons.delete_outline,
                    defaultColor: Colors.grey,
                    hoverColor: Colors.red,
                    iconSize: Dimensions.iconSize,
                    onPressed: onDeleteButtonTap,
                  ),
                  SizedBox(
                    width: Dimensions.sizeboxWidth * 1.5,
                  ),
                  HoverIconButton(
                    splashColor:
                        const Color.fromARGB(255, 81, 151, 208).withOpacity(.4),
                    icon: Icons.edit_outlined,
                    defaultColor: Colors.grey,
                    hoverColor: const Color.fromARGB(255, 81, 151, 208),
                    iconSize: Dimensions.iconSize,
                    onPressed: onEditButtonTap,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.sizeboxWidth * 3,
            ),
            // data table here

            Flexible(
              fit: FlexFit.tight,
              child: CustomDataTable(
                columns: columns,
                rows: rows,
                widthforMorecolumns: widthforMorecolumns,
              ),
            ),

            // CustomDataGrid(columns: GridColumncolumns, rows: Datarows)

            if (showPrintChequeButton || showPrintReceiptButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showPrintChequeButton)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .grey.shade300, // Specify the background color here
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Add rounded corners
                      ),
                      child: TextButton(
                        onPressed:
                            onPrintChequeTap, // Use the provided callback
                        child: const Text(
                          "Print Cheque",
                          style: TextStyle(color: AppConstants.BlackTxtColor),
                        ),
                      ),
                    ),
                  if (showPrintReceiptButton)
                    SizedBox(
                        width: 10), // Add spacing between buttons if needed
                  if (showPrintReceiptButton)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .grey.shade300, // Specify the background color here
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Add rounded corners
                      ),
                      child: TextButton(
                        onPressed:
                            onPrintReceiptTap, // Use the provided callback
                        child: const Text(
                          "Print Receipt",
                          style: TextStyle(color: AppConstants.BlackTxtColor),
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

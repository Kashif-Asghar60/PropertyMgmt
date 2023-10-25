import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constants.dart';

GridColumn createCustomGridColumn(String columnName, String labelText) {
  return GridColumn(
    autoFitPadding: EdgeInsets.all(6),
    minimumWidth: Dimensions.buttonWidth,
    maximumWidth: Dimensions.buttonWidth * 4,
    columnWidthMode: ColumnWidthMode.auto,
    columnName: columnName,
    label: Center(
      child: Text(
        labelText,
        style: TextStyle(
            color: AppConstants.whiteTxtColor, fontSize: Dimensions.textSize),
      ),
    ),
  );
}

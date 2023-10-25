import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../constants.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn2> columns;
  final List<DataRow> rows;
  final double widthforMorecolumns;

  CustomDataTable({
    required this.columns,
    required this.rows,
    this.widthforMorecolumns = 1,
  });

  double tableTextSize = Dimensions.textSize / 1.3;


  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
     // shrinkWrap: true,
      children: [
        SizedBox(
          height: Dimensions.screenHeight,
            width: Dimensions.screenWidth * widthforMorecolumns,
            child: buildDataTable2())
      ],
    );
  }

  Widget buildDataTable2() {
    bool isOdd = false; // Initialize isOdd to false
    return DataTable2(
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      columnSpacing: 12,
      scrollController: _controller,
      minWidth: Dimensions.dataCellWidth / 1.5,
      headingRowHeight: tableTextSize * 4,
      dividerThickness: 1.0,
      border: TableBorder.all(color: Colors.grey),
      horizontalMargin: 5,
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppConstants.whiteTxtColor,
        fontSize: tableTextSize,
      ),
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => AppConstants.purplethemecolor,
      ),
      dataRowColor: MaterialStateColor.resolveWith(
        (states) {
          isOdd = !isOdd; // Toggle row color
          return isOdd
              ? AppConstants.whiteTxtColor // Color for odd rows
              : Colors.grey[200]!; // Color for even rows (zebra striping)
        },
      ),
      dataTextStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: AppConstants.purplethemecolor,
        fontSize: 12,
      ),
      columns: columns,
      rows: rows,
    );
  }
}

/* 
class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  CustomDataTable({
    required this.columns,
    required this.rows,
  });

  double tableTextSize = Dimensions.textSize / 1.3;

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Determine if horizontal scrolling is needed based on the number of columns
    bool enableHorizontalScroll = columns.length > 7;

    return Container(
        //  color: Colors.indigoAccent,
        width: Dimensions.dataTableWidth,
        height: Dimensions.contentscreenHeight, // Set the desired height
        child: Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: true,
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
              controller: _vertical,
              child: SingleChildScrollView(
                controller: _horizontal,
                scrollDirection: Axis.horizontal,
                child: buildDataTable(),
              ),
            ),
          ),
        )
        /*   : Scrollbar(
              controller: _vertical,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _vertical,
                child: buildDataTable(),
              ),
            ), */
        );
  }

  Widget buildDataTable() {
    return Expanded(
      child: DataTable(
        headingRowHeight: tableTextSize * 4,
        dataRowMaxHeight: double.infinity,
        dataRowMinHeight: 10, //tableTextSize - 2,
        dividerThickness: 1.0,
        border: TableBorder.all(color: Colors.grey),
        horizontalMargin: 5,
        headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppConstants.whiteTxtColor,
          fontSize: tableTextSize,
        ),
        headingRowColor: MaterialStateProperty.resolveWith(
          (states) => AppConstants.purplethemecolor,
        ),
        dataRowColor: MaterialStateProperty.resolveWith(
          (states) => AppConstants.whiteTxtColor,
        ),
        dataTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: AppConstants.purplethemecolor,
          fontSize: 12, //tableTextSize,
        ),
        columns: columns,
        rows: rows,
      ),
    );
  }
}
 */
/* 
class CustomDataGrid extends StatelessWidget {
  final List<GridColumn> columns;
  final List<DataRow> rows;

  CustomDataGrid({
    required this.columns,
    required this.rows,
  });

  double tableTextSize = Dimensions.textSize / 1.3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.dataTableWidth,
      height: Dimensions.contentscreenHeight,
      child: SfDataGridTheme(
        data: SfDataGridThemeData(
            headerColor: AppConstants.purplethemecolor,
            gridLineColor: Colors.grey,
            gridLineStrokeWidth: 2),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnResizeMode: ColumnResizeMode.onResize,
          columnWidthMode: ColumnWidthMode.auto,
          source: _CustomDataSource(columns, rows),
          columns: columns,
          rowHeight: 150,
          onQueryRowHeight: (details) {
            return details.getIntrinsicRowHeight(details.rowIndex);
          },
        ),
      ),
    );
  }
}

class _CustomDataSource extends DataGridSource {
  _CustomDataSource(this.columns, List<DataRow> rows) {
    _dataRows = rows;
    _buildDataGridRows();
  }

  final List<GridColumn> columns;
  List<DataRow> _dataRows = [];
  List<DataGridRow> _gridRows = [];

  void _buildDataGridRows() {
    _gridRows.clear();
    for (int i = 0; i < _dataRows.length; i++) {
      _gridRows.add(DataGridRow(
          cells: _convertDataCellsToDataGridCells(_dataRows[i].cells)));
    }
  }

  List<DataGridCell<dynamic>> _convertDataCellsToDataGridCells(
      List<DataCell> dataCells) {
    return dataCells.map((dataCell) {
      return DataGridCell<dynamic>(
        columnName: columns[dataCells.indexOf(dataCell)].columnName,
        value: dataCell.child,
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _gridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: AppConstants.whitecontainer,
      cells: row.getCells().map<Widget>((e) {
        final cellValue = e.value;
        return Center(
          child: cellValue is Widget // Check if it's a Widget
              ? cellValue
              : Text(
                  cellValue != null
                      ? cellValue.toString()
                      : '', // Display the value or an empty string if it's null
                  softWrap: true,
                  style: TextStyle(
                    //   overflow: TextOverflow.clip,
                    fontSize: Dimensions
                        .Txtfontsize, // Adjust the font size as needed
                    color: AppConstants.purplethemecolor,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
 */
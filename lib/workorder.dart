import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dashboard.dart';
import 'package:mainportal/main.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(workorder());
}

class workorder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Work Order',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: JsonDataGrid(),
    );
  }
}

class JsonDataGrid extends StatefulWidget {
  @override
  _JsonDataGridState createState() => _JsonDataGridState();
}

class _JsonDataGridState extends State<JsonDataGrid> {
  late _JsonDataGridSource jsonDataGridSource;
  List<_Product> productlist = [];
  List<_Product> filteredList = [];
  TextEditingController _filterController = TextEditingController();
  bool _isDataFetched = false;
  String? _selectedPriorityFilter;
  String _searchFilter = '';

  final FocusNode _searchFocusNode = FocusNode();

  Future<void> generateProductList() async {
    var response =
        await http.post(Uri.parse("http://localhost:3030/workorder"));
    var list =
        json.decode(response.body)['data227'].cast<Map<String, dynamic>>();
    productlist =
        list.map<_Product>((dynamic json) => _Product.fromJson(json)).toList();

    if (productlist.isNotEmpty) {
      productlist.removeAt(0);
    }

    filteredList = List.from(productlist);
    jsonDataGridSource.updateDataSource(filteredList);

    setState(() {
      _isDataFetched = true;
    });
  }

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = ([
      GridColumn(
        columnName: 'Order ID',
        width: 215,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'ORDER ID',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Work Centre',
        width: 150,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'WORK CENTRE',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Plant',
        width: 120,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'PLANT',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Start Date',
        width: 150,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'START DATE',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Finish Date',
        width: 150,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'FINISH DATE',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Received Notification',
        width: 300,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'DESCRIPTION',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Equipment',
        width: 250,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'EQUIPMENT',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Priority Status',
        width: 200,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'PRIORITY STATUS',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    ]);
    return columns;
  }

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyApp()),
    );
  }

  void filterData() {
    setState(() {
      filteredList = productlist
          .where((product) =>
              product.ORDER_ID
                      ?.toLowerCase()
                      .contains(_searchFilter.toLowerCase()) ==
                  true &&
              (_selectedPriorityFilter == null ||
                  product.Priority_Status?.toLowerCase() ==
                      _selectedPriorityFilter?.toLowerCase()))
          .toList();
      jsonDataGridSource.updateDataSource(filteredList);
    });
  }

  void clearPriorityFilter() {
    setState(() {
      _selectedPriorityFilter = null;
      filterData();
    });
  }

  void clearNotificationFilter() {
    setState(() {
      _filterController.clear();
      _searchFilter = '';
      filterData();
    });
  }

  int findIndexOfProduct(_Product product) {
    return productlist.indexWhere((item) => item == product);
  }

  void _showDetails(BuildContext context, _Product product) {
    if (_searchFocusNode.hasFocus || _filterController.text.isNotEmpty) {
      return;
    }
    final selectedIndex = findIndexOfProduct(product);
    final int beforeSelectedIndex = selectedIndex - 1;

    if (beforeSelectedIndex >= 0) {
      final beforeSelectedProduct = productlist[beforeSelectedIndex];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          return AlertDialog(
            title: Text(
              'Details for Order ID: ${beforeSelectedProduct.ORDER_ID}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRowWidget(
                  'Work Centre',
                  beforeSelectedProduct.WORK_CENTRE,
                ),
                _buildDetailRowWidget('Plant', beforeSelectedProduct.PLANT),
                _buildDetailRowWidget(
                  'Start Date',
                  dateFormat.format(
                      DateTime.parse(beforeSelectedProduct.START_DATE ?? '')),
                ),
                _buildDetailRowWidget(
                  'Finish Date',
                  dateFormat.format(
                      DateTime.parse(beforeSelectedProduct.FIN_DATE ?? '')),
                ),
                _buildDetailRowWidget(
                  'Received Notification',
                  beforeSelectedProduct.DESCRIPTION,
                ),
                _buildDetailRowWidget(
                  'Equipment',
                  beforeSelectedProduct.Location,
                ),
                _buildDetailRowWidget(
                  'Priority Status',
                  beforeSelectedProduct.Priority_Status,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildDetailRowWidget(String title, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value ?? 'null',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    jsonDataGridSource = _JsonDataGridSource([]);
    generateProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          ),
        ),
        actions: [
          Tooltip(
            message: "Logout",
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'WORK ORDER',
          style: TextStyle(
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: TextField(
                        controller: _filterController,
                        decoration: InputDecoration(
                          labelText: 'Search by ORDER ID',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: clearNotificationFilter,
                          ),
                        ),
                        onChanged: (value) {
                          _searchFilter = value;
                          filterData();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 0.0,
                          bottom:
                              5.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedPriorityFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPriorityFilter = newValue;
                            filterData();
                          });
                        },
                        items: PriorityFilter.options
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'PRIORITY STATUS',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 5.0),
                    child: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: clearPriorityFilter,
                    ),
                  ),
                ],
              ),
            ),
            _isDataFetched
                ? filteredList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No data available.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    : Expanded(
                        child: SfDataGrid(
                          source: jsonDataGridSource,
                          columns: getColumns(),
                          onCellTap: (DataGridCellTapDetails args) {
                            if (args.rowColumnIndex.rowIndex != -1 &&
                                args.rowColumnIndex.columnIndex != -1) {
                              final int rowIndex = args.rowColumnIndex.rowIndex;
                              final int columnIndex =
                                  args.rowColumnIndex.columnIndex;
                              if (columnIndex >= 0 && rowIndex >= 0) {
                                final selectedProduct = filteredList[rowIndex];
                                _showDetails(context, selectedProduct);
                              }
                            }
                          },
                        ),
                      )
                : Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 100.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _Product {
  factory _Product.fromJson(Map<String, dynamic> json) {
    return _Product(
      ORDER_ID: json['ORDERID']['_text'] as String?,
      WORK_CENTRE: json['WORK_CNTR']['_text'] as String?,
      PLANT: json['PLANT']['_text'] as String?,
      START_DATE: json['EARL_SCHED_START_DATE']['_text'] as String?,
      FIN_DATE: json['EARL_SCHED_FINISH_DATE']['_text'] as String?,
      DESCRIPTION: json['DESCRIPTION']['_text'] as String?,
      Location: json['EQUIDESCR']['_text'] as String?,
      Priority_Status: json['PRIOTYPE_DESC']['_text'] as String?,
    );
  }
  _Product({
    this.ORDER_ID,
    this.WORK_CENTRE,
    this.PLANT,
    this.START_DATE,
    this.FIN_DATE,
    this.DESCRIPTION,
    this.Location,
    this.Priority_Status,
  });
  String? ORDER_ID;
  String? WORK_CENTRE;
  String? PLANT;
  String? START_DATE;
  String? FIN_DATE;
  String? DESCRIPTION;
  String? Location;
  String? Priority_Status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ORDERID': ORDER_ID,
      'WORK_CNTR': WORK_CENTRE,
      'PLANT': PLANT,
      'EARL_SCHED_START_DATE': START_DATE,
      'EARL_SCHED_FINISH_DATE': FIN_DATE,
      'DESCRIPTION': DESCRIPTION,
      'EQUIDESCR': Location,
      'PRIOTYPE_DESC': Priority_Status,
    };
  }
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this._dataGridRow);
  List<DataGridRow> _dataGridRow = [];

  void updateDataSource(List<_Product> product) {
    _dataGridRow = product.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Order ID', value: dataGridRow.ORDER_ID),
        DataGridCell<String>(
            columnName: 'Work Centre', value: dataGridRow.WORK_CENTRE),
        DataGridCell<String>(columnName: 'Plant', value: dataGridRow.PLANT),
        DataGridCell<String>(
            columnName: 'Start Date', value: dataGridRow.START_DATE),
        DataGridCell<String>(
            columnName: 'Finish Date', value: dataGridRow.FIN_DATE),
        DataGridCell<String>(
            columnName: 'Received Notification',
            value: dataGridRow.DESCRIPTION),
        DataGridCell<String>(
            columnName: 'Equipment', value: dataGridRow.Location),
        DataGridCell<String>(
            columnName: 'Priority Status', value: dataGridRow.Priority_Status),
      ]);
    }).toList();
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => _dataGridRow;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          dateFormat.format(DateTime.parse(row.getCells()[3].value.toString())),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          dateFormat.format(DateTime.parse(row.getCells()[4].value.toString())),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.visible,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[7].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }
}

class PriorityFilter {
  static const options = [
    '1-Very high',
    '2-High',
  ];
}

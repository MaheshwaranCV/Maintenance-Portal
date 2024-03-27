import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mainportal/main.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'dashboard.dart';

void main() {
  runApp(notification());
}

class notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Details',
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
  int selectedRowIndex = -1;
  String? _selectedPriorityFilter;

  final FocusNode _searchFocusNode = FocusNode();

  Future<void> generateProductList() async {
    var response = await http.post(Uri.parse("http://localhost:3030/notlist"));
    var list =
        json.decode(response.body)['data227'].cast<Map<String, dynamic>>();
    productlist =
        list.map<_Product>((dynamic json) => _Product.fromJson(json)).toList();
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
        columnName: 'Notification No',
        width: 160,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'NOTIFICATION NO',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Type',
        width: 110,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'TYPE',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Date',
        width: 140,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'DATE',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Location',
        width: 160,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'LOCATION',
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Notification',
        width: 290,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'NOTIFICATION',
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Equipment',
        width: 230,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'EQUIPMENT',
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Description',
        width: 335,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'DESCRIPTION',
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Priority',
        width: 110,
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.blue.shade200,
          alignment: Alignment.center,
          child: Text(
            'PRIORITY',
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
        builder: (context) => MyApp(),
      ),
    );
  }

  void filterData(String orderId, String? priority) {
    setState(() {
      filteredList = productlist
          .where((product) =>
              product.ORDER_ID?.toLowerCase().contains(orderId.toLowerCase()) ==
                  true &&
              (priority == null || product.DESCRIPTION == priority))
          .toList();
      jsonDataGridSource.updateDataSource(filteredList);
    });
  }

  void clearFilter() {
    _filterController.clear();
    filterData('', _selectedPriorityFilter);
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
          return AlertDialog(
            title: Text(
              'Details for Notification No: ${beforeSelectedProduct.ORDER_ID}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRowWidget(
                    'Type', beforeSelectedProduct.WORK_CENTRE),
                _buildDetailRowWidget('Date', beforeSelectedProduct.PLANT),
                _buildDetailRowWidget(
                    'Location', beforeSelectedProduct.START_DATE),
                _buildDetailRowWidget(
                    'Notification', beforeSelectedProduct.FIN_DATE),
                _buildDetailRowWidget(
                    'Equipment', beforeSelectedProduct.EQUIPMENT),
                 _buildDetailRowWidget(
                    'Description', beforeSelectedProduct.DESCRI),
                _buildDetailRowWidget(
                    'Priority', beforeSelectedProduct.DESCRIPTION),
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
    final dateFormat = DateFormat('dd-MM-yyyy');
    final formattedValue = (title == 'Date' && value != null)
        ? dateFormat.format(DateTime.parse(value))
        : value;

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
              text: formattedValue ?? 'null',
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
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()))
          },
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
          'NOTIFICATION DETAILS',
          style: TextStyle(
            letterSpacing: 2.0,
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
                      padding: const EdgeInsets.only(right: 8.0, top: 10.0),
                      child: TextField(
                        controller: _filterController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Search by NOTIFICATION NO',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: clearFilter,
                          ),
                        ),
                        onChanged: (value) {
                          filterData(value, _selectedPriorityFilter);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: DropdownButtonFormField<String>(
                                value: _selectedPriorityFilter,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedPriorityFilter = newValue;
                                    filterData(
                                        _filterController.text, newValue);
                                  });
                                },
                                items: PriorityFilter.options
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'PRIORITY',
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _selectedPriorityFilter = null;
                                filterData(_filterController.text, null);
                              });
                            },
                          ),
                        ],
                      ),
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
                        child: CircularProgressIndicator(strokeWidth: 3),
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
      ORDER_ID: json['NOTIFICAT']['_text'],
      WORK_CENTRE: json['NOTIF_TYPE']['_text'],
      PLANT: json['STARTDATE']['_text'],
      START_DATE: json['FUNCLOC']['_text'],
      FIN_DATE: json['FUNCLDESCR']['_text'],
      EQUIPMENT: json['EQUIDESCR']['_text'],
      DESCRI: json['DESCRIPT']['_text'],
      DESCRIPTION: json['PRIORITY']['_text'],
    );
  }

  _Product({
    this.ORDER_ID,
    this.WORK_CENTRE,
    this.PLANT,
    this.START_DATE,
    this.FIN_DATE,
    this.EQUIPMENT,
    this.DESCRI,
    this.DESCRIPTION,
  });

  String? ORDER_ID;
  String? WORK_CENTRE;
  String? PLANT;
  String? START_DATE;
  String? FIN_DATE;
  String? EQUIPMENT;
  String? DESCRI;
  String? DESCRIPTION;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ORDER_ID': ORDER_ID,
        'WORK_CENTRE': WORK_CENTRE,
        'PLANT': PLANT,
        'START_DATE': START_DATE,
        'FIN_DATE': FIN_DATE,
        'EQUIPMENT':EQUIPMENT,
        'DESCRIPT':DESCRI,
        'DESCRIPTION': DESCRIPTION,
      };
}

class PriorityFilter {
  static const List<String> options = [
    '1',
    '2',
  ];
}

class _JsonDataGridSource extends DataGridSource {
  _JsonDataGridSource(this._dataGridRow);
  List<DataGridRow> _dataGridRow = [];

  void updateDataSource(List<_Product> product) {
    _dataGridRow = product.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'ORDER_ID', value: dataGridRow.ORDER_ID),
        DataGridCell<String>(
            columnName: 'WORK_CENTRE', value: dataGridRow.WORK_CENTRE),
        DataGridCell<String>(columnName: 'PLANT', value: dataGridRow.PLANT),
        DataGridCell<String>(
            columnName: 'START_DATE', value: dataGridRow.START_DATE),
        DataGridCell<String>(
            columnName: 'FIN_DATE', value: dataGridRow.FIN_DATE),
        DataGridCell<String>(
            columnName: 'EQUIPMENT', value: dataGridRow.EQUIPMENT),
        DataGridCell<String>(
            columnName: 'DESCRI', value: dataGridRow.DESCRI),
        DataGridCell<String>(
            columnName: 'DESCRIPTION', value: dataGridRow.DESCRIPTION),
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
          dateFormat.format(DateTime.parse(row.getCells()[2].value.toString())),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.visible,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
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

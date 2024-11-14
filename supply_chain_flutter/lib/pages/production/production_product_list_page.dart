import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';
import 'package:intl/intl.dart';

import '../../dialog/warehouse_select_dialog.dart';
import '../../dialog/add_production_product_dialog.dart';
import '../../util/apiresponse.dart';

class ProductionProductListPage extends StatefulWidget {
  final int? warehouseId;
  ProductionProductListPage({this.warehouseId});
  @override
  _ProductionProductListPageState createState() =>
      _ProductionProductListPageState();
}

class _ProductionProductListPageState extends State<ProductionProductListPage> {
  List<ProductionProduct> prodProducts = [];

  @override
  void initState() {
    super.initState();
    if (widget.warehouseId != null) {
      loadProdProductsByWarehouse(widget.warehouseId!);
    } else {
      loadAllProdProducts();
    }
  }

  Future<void> loadAllProdProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/productionProduct/list'));
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      if (apiResponse.success) {
        setState(() {
          List<dynamic> prodProductsJson = apiResponse.data?['productionProducts'];
          prodProducts = List<ProductionProduct>.from(
              prodProductsJson.map((x) => ProductionProduct.fromJson(x)));
        });
      } else {
        NotifyUtil.error(context, 'Failed to load production products.');
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }

  Future<void> loadProdProductsByWarehouse(int warehouseId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:8080/api/productionProduct/warehouse/$warehouseId'));
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      if (apiResponse.success) {
        setState(() {
          List<dynamic> prodProductsJson = apiResponse.data?['prodProducts'];
          prodProducts = List<ProductionProduct>.from(
              prodProductsJson.map((x) => ProductionProduct.fromJson(x)));
        });
      } else {
        NotifyUtil.error(context, 'Failed to load production products for the selected warehouse.');
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }


  Future<void> updateStatus(int? id, ProductionStatus newStatus) async {
    if (newStatus == ProductionStatus.MOVED_TO_WAREHOUSE) {
      final selectedWarehouse = await showDialog<Warehouse>(
        context: context,
        builder: (context) => WarehouseSelectDialog(),
      );

      if (selectedWarehouse != null && id != null) {
        await _updateStatusOnServer(id, newStatus,
            warehouseId: selectedWarehouse.id);
      }
    } else if (id != null) {
      await _updateStatusOnServer(id, newStatus);
    } else {
      NotifyUtil.error(context, 'No ID');
    }
  }

  Future<void> _updateStatusOnServer(int id, ProductionStatus newStatus,
      {int? warehouseId}) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/productionProduct/status/$id')
            .replace(queryParameters: {
          'status': newStatus.toString().split('.').last,
          if (warehouseId != null) 'warehouseId': warehouseId.toString(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiResponse.success) {
        NotifyUtil.success(context, apiResponse.message);
        loadAllProdProducts();
      } else {
        NotifyUtil.error(context, apiResponse.message);
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('yyyy-MM-dd').format(dateTime); // Date only
  }

  String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('HH:mm').format(dateTime); // Time only (hour and minute)
  }

  Future<void> openAddProductionProductDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProductionProductDialog(
        onSave: loadAllProdProducts,
      ),
    );

    if (result == true) {
      loadAllProdProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Products'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Production Products',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prodProducts.length,
                itemBuilder: (context, index) {
                  final product = prodProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.label, color: Colors.blueAccent),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Product Name: ${product.product?.name}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                Text('Batch Number: ${product.batchNumber}'),
                                Text('Quantity: ${product.quantity}'),
                                Text(
                                    'Status: ${product.status.toString().split('.').last}'),

                                // Date and time with different colors
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Completion Date: ',
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                      TextSpan(
                                        text: formatDate(product.completionDate),
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                      TextSpan(
                                        text: ' ${formatTime(product.completionDate)}',
                                        style: TextStyle(color: Colors.orangeAccent),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Warehouse Date: ',
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                      TextSpan(
                                        text: formatDate(product.movedToWarehouseDate),
                                        style: TextStyle(color: Colors.teal),
                                      ),
                                      TextSpan(
                                        text: ' ${formatTime(product.movedToWarehouseDate)}',
                                        style: TextStyle(color: Colors.orangeAccent),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              if (product.status != ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => updateStatus(
                                      product.id, ProductionStatus.COMPLETED),
                                  child: Text('Complete'),
                                ),
                              if (product.status == ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => updateStatus(
                                      product.id,
                                      ProductionStatus.MOVED_TO_WAREHOUSE),
                                  child: Text('Move to Warehouse'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProductionProductDialog,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        tooltip: 'Add Production Product',
      ),
    );
  }
}

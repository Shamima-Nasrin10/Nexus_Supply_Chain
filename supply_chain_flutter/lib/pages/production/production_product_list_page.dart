import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../../dialog/warehouse_select_dialog.dart';
import '../../dialog/add_production_product_dialog.dart';
import '../../util/apiresponse.dart';

class ProductionProductListPage extends StatefulWidget {
  @override
  _ProductionProductListPageState createState() =>
      _ProductionProductListPageState();
}

class _ProductionProductListPageState extends State<ProductionProductListPage> {
  List<ProductionProduct> prodProducts = [];

  @override
  void initState() {
    super.initState();
    loadProdProducts();
  }

  Future<void> loadProdProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/productionProduct/list'));
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
      if (apiResponse.success) {
        setState(() {
          List<dynamic> prodProductsJson = apiResponse.data?['productionProducts'];
          prodProducts = List<ProductionProduct>.from(prodProductsJson.map((x) => ProductionProduct.fromJson(x)));
        });
      } else {
        NotifyUtil.error(context, 'Failed to load production products.');
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
          if (warehouseId != null) 'warehouseId': warehouseId.toString(), // Only include if warehouseId is not null
        }),
        headers: {'Content-Type': 'application/json'},
      );
      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiResponse.success) {
        NotifyUtil.success(context, apiResponse.message);
        loadProdProducts();
      } else {
        NotifyUtil.error(context, apiResponse.message);
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }

  Future<void> openAddProductionProductDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddProductionProductDialog(
        onSave: loadProdProducts, // Reload the list after saving
      ),
    );

    if (result == true) {
      loadProdProducts(); // Reload the list if a product was added successfully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production Products List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Production Products List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prodProducts.length,
                itemBuilder: (context, index) {
                  final product = prodProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product Name: ${product.product?.name}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Batch Number: ${product.batchNumber}'),
                              Text('Quantity: ${product.quantity}'),
                              Text(
                                  'Status: ${product.status.toString().split('.').last}'),
                              Text(
                                  'Completion Date: ${product.completionDate?.toString() ?? '-'}'),
                              Text(
                                  'Warehouse Date: ${product.movedToWarehouseDate?.toString() ?? '-'}'),
                            ],
                          ),
                          Column(
                            children: [
                              if (product.status != ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  onPressed: () => updateStatus(
                                      product?.id, ProductionStatus.COMPLETED),
                                  child: Text('Mark as Completed'),
                                ),
                              if (product.status == ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  onPressed: () => updateStatus(product?.id,
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
        child: Icon(Icons.add),
        tooltip: 'Add Production Product',
      ),
    );
  }
}

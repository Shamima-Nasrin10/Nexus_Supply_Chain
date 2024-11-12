import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/production_product_model.dart';
import 'package:supply_chain_flutter/model/production/warehouse_model.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../../dialog/warehouse_select_dialog.dart';
import '../../dialog/add_production_product_dialog.dart';

class ProductionProductListPage extends StatefulWidget {
  @override
  _ProductionProductListPageState createState() => _ProductionProductListPageState();
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
      final response = await http.get(Uri.parse('http://localhost:8080/api/productionProduct/list'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          prodProducts = (data['productionProducts'] as List)
              .map((item) => ProductionProduct.fromJson(item))
              .toList();
        });
      } else {
        NotifyUtil.error(context, 'Failed to load production products.');
      }
    } catch (error) {
      NotifyUtil.error(context, error.toString());
    }
  }

  Future<void> updateStatus(int id, ProductionStatus newStatus) async {
    if (newStatus == ProductionStatus.MOVED_TO_WAREHOUSE) {
      final selectedWarehouse = await showDialog<Warehouse>(
        context: context,
        builder: (context) => WarehouseSelectDialog(),
      );

      if (selectedWarehouse != null) {
        await _updateStatusOnServer(id, newStatus, warehouseId: selectedWarehouse.id);
      }
    } else {
      await _updateStatusOnServer(id, newStatus);
    }
  }

  Future<void> _updateStatusOnServer(int id, ProductionStatus newStatus, {int? warehouseId}) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/productionProduct/status/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': newStatus.toString().split('.').last,
          'warehouseId': warehouseId,
        }),
      );
      if (response.statusCode == 200) {
        NotifyUtil.success(context, 'Status updated successfully.');
        loadProdProducts();
      } else {
        NotifyUtil.error(context, 'Failed to update status.');
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
                              Text('Product Name: ${product.product.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Batch Number: ${product.batchNumber}'),
                              Text('Quantity: ${product.quantity}'),
                              Text('Status: ${product.status.toString().split('.').last}'),
                              Text('Completion Date: ${product.completionDate?.toString() ?? '-'}'),
                              Text('Warehouse Date: ${product.movedToWarehouseDate?.toString() ?? '-'}'),
                            ],
                          ),
                          Column(
                            children: [
                              if (product.status != ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  onPressed: () => updateStatus(product.id, ProductionStatus.COMPLETED),
                                  child: Text('Mark as Completed'),
                                ),
                              if (product.status == ProductionStatus.COMPLETED)
                                ElevatedButton(
                                  onPressed: () => updateStatus(product.id, ProductionStatus.MOVED_TO_WAREHOUSE),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';
import 'package:supply_chain_flutter/service/raw_material/raw_material_service.dart';
import 'package:supply_chain_flutter/service/production/product_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

import '../util/apiresponse.dart';

class AddProductionProductDialog extends StatefulWidget {
  final VoidCallback onSave;

  AddProductionProductDialog({required this.onSave});

  @override
  _AddProductionProductDialogState createState() => _AddProductionProductDialogState();
}

class _AddProductionProductDialogState extends State<AddProductionProductDialog> {
  final TextEditingController batchNumberTEC = TextEditingController();
  final TextEditingController quantityTEC = TextEditingController(text: '0');
  List<Product> products = [];
  List<RawMaterial> rawMaterials = [];
  List<Map<String, dynamic>> rawMatUsages = [];

  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadRawMaterials();
  }

  Future<void> _loadProducts() async {
    final response = await ProductService().getAllProducts();
    if (response.success) {
      setState(() {
        products = (response.data?['products'] as List)
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load products');
    }
  }

  Future<void> _loadRawMaterials() async {
    final response = await RawMaterialService().getRawMaterials();
    if (response.success) {
      setState(() {
        rawMaterials = (response.data?['rawMaterials'] as List)
            .map((json) => RawMaterial.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    } else {
      NotifyUtil.error(context, response.message ?? 'Failed to load raw materials');
    }
  }

  void _addRawMatUsage() {
    setState(() {
      rawMatUsages.add({
        'rawMaterial': null,
        'quantity': 0,
      });
    });
  }

  void _removeRawMatUsage(int index) {
    setState(() {
      rawMatUsages.removeAt(index);
    });
  }

  Future<void> _saveProductionProduct() async {
    if (batchNumberTEC.text.isEmpty || quantityTEC.text.isEmpty || selectedProduct == null) {
      NotifyUtil.error(context, 'Please fill out all required fields');
      return;
    }

    try {
      final productionProduct = {
        'product': selectedProduct?.id,
        'batchNumber': int.parse(batchNumberTEC.text),
        'quantity': int.parse(quantityTEC.text),
        'rawMatUsages': rawMatUsages.map((usage) {
          return {
            'rawMaterial': usage['rawMaterial']?.id,
            'quantity': usage['quantity'],
          };
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/productionProduct/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productionProduct),
      );

      ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiResponse.success) {
        NotifyUtil.success(context, apiResponse.message);
        widget.onSave();
        Navigator.of(context).pop();
      } else {
        NotifyUtil.error(context, apiResponse.message);
      }
    } catch (e) {
      NotifyUtil.error(context, 'Error saving product: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Production Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: batchNumberTEC,
              decoration: InputDecoration(labelText: 'Batch Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityTEC,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Product>(
              hint: Text('Select Product'),
              value: selectedProduct,
              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (Product? selected) {
                setState(() {
                  selectedProduct = selected;
                });
              },
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ...rawMatUsages.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> usage = entry.value;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<RawMaterial>(
                          hint: Text('Select Material'),
                          value: usage['rawMaterial'],
                          items: rawMaterials.map((rawMaterial) {
                            return DropdownMenuItem(
                              value: rawMaterial,
                              child: Text(rawMaterial.name),
                            );
                          }).toList(),
                          onChanged: (RawMaterial? selected) {
                            setState(() {
                              usage['rawMaterial'] = selected;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              usage['quantity'] = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeRawMatUsage(index),
                      ),
                    ],
                  );
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addRawMatUsage,
                    icon: Icon(Icons.add),
                    label: Text('Add Raw Material Usage'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveProductionProduct,
          child: Text('Save'),
        ),
      ],
    );
  }
}

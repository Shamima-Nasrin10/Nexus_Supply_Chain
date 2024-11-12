import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supply_chain_flutter/model/production/product_model.dart';
import 'package:supply_chain_flutter/model/raw_material/raw_material_model.dart';
import 'package:supply_chain_flutter/service/raw_material/raw_material_service.dart';
import 'package:supply_chain_flutter/service/production/product_service.dart';
import 'package:supply_chain_flutter/util/notify_util.dart';

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
              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (Product? selectedProduct) {
                setState(() {
                  // Assign the selected product as needed
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<RawMaterial>(
              hint: Text('Select Raw Material'),
              items: rawMaterials.map((rawMaterial) {
                return DropdownMenuItem(
                  value: rawMaterial,
                  child: Text(rawMaterial.name),
                );
              }).toList(),
              onChanged: (RawMaterial? selectedRawMaterial) {
                setState(() {
                  // Assign the selected raw material as needed
                });
              },
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
          onPressed: () {
            // Save action
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
